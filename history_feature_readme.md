# Exam History Feature Implementation

Chức năng Lịch sử làm bài (Exam History) được triển khai theo đúng chuẩn Clean Architecture với việc tách biệt hoàn toàn giữa UI, Business Logic và Data Access.

## 1. Mục tiêu chức năng
* Giúp người dùng xem lại danh sách các bài thi đã làm.
* Hiển thị chi tiết thời gian, điểm số, và tỷ lệ đúng/sai.
* Cung cấp khả năng xóa lịch sử làm bài để dọn dẹp dữ liệu.
* Tự động lấy lịch sử theo UID của người dùng đang đăng nhập (không load nhầm dữ liệu người khác).

## 2. Luồng nghiệp vụ
1. **Khởi tạo:** Khi người dùng mở `ExamHistoryScreen`, hàm `initState` sẽ kích hoạt `fetchHistory()` trên `ExamHistoryCubit`.
2. **Lấy dữ liệu:** Cubit gọi `GetExamHistoryUseCase` -> `HistoryRepository` -> `HistoryRemoteDataSource`. 
3. **Firestore Query:** Data Source sẽ query Firestore Collection `users/{uid}/exam_history` sắp xếp theo ngày nộp bài mới nhất.
4. **Hiển thị:** Cubit emit `ExamHistoryLoaded`, UI sẽ hiển thị danh sách lịch sử.
5. **Xóa:** Người dùng bấm "Xóa" -> Hiển thị popup xác nhận -> Gọi `deleteHistory()` -> Xóa trên Firestore -> UI cập nhật lại ngay lập tức mà không cần fetch lại toàn bộ dữ liệu.

## 3. Kiến trúc
* **Presentation Layer:** `ExamHistoryScreen` lắng nghe `ExamHistoryCubit`. Hiển thị Loading, Empty, Data hoặc Error.
* **Domain Layer:** Chứa `ExamHistoryEntity`, các Abstract `HistoryRepository`, và các `UseCases` (Get, Delete, Save). Lớp này không phụ thuộc vào Firebase.
* **Data Layer:** Chứa `ExamHistoryModel` (chuyển đổi JSON) và `HistoryRemoteDataSourceImpl` (Giao tiếp trực tiếp với Firestore).

## 4. Cấu trúc folder
Các file mới được đặt trọn vẹn trong module `lib/src/features/history/` để tránh phình to module Profile. 
```txt
lib/src/features/history/
├── data/
│   ├── datasources/history_remote_data_source.dart
│   ├── models/exam_history_model.dart
│   └── repositories/history_repository_impl.dart
├── domain/
│   ├── entities/exam_history_entity.dart
│   ├── repositories/history_repository.dart
│   └── usecases/
│       ├── delete_exam_history_usecase.dart
│       ├── get_exam_history_usecase.dart
│       └── save_exam_history_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── exam_history_cubit.dart
    │   └── exam_history_state.dart
    └── pages/
        └── exam_history_screen.dart
```
File đã sửa:
* `lib/app/di/injection_container.dart` (Đăng ký Dependency).
* `lib/src/core/router/app_router.dart` (Bọc BlocProvider).

## 5. Firestore schema
Dữ liệu được lưu tại đường dẫn phân cấp:
`users/{uid}/exam_history/{historyId}`

Cấu trúc một document:
* `examId` (String): ID của đề thi.
* `examTitle` (String): Tên đề thi.
* `subjectId` (String): ID môn học.
* `subjectName` (String): Tên môn học.
* `score` (Number): Điểm số.
* `totalQuestions` (Number): Tổng số câu.
* `correctAnswers` (Number): Số câu đúng.
* `wrongAnswers` (Number): Số câu sai.
* `skippedAnswers` (Number): Số câu bỏ qua.
* `accuracy` (Number): Tỷ lệ đúng (%).
* `duration` (Number): Thời gian giới hạn (giây).
* `timeSpent` (Number): Thời gian đã làm (giây).
* `submittedAt` (Timestamp): Thời điểm nộp bài.

## 6. State Management
Dùng **Cubit** (`ExamHistoryCubit`) và **Equatable** (`ExamHistoryState`).
Các state chính:
* `ExamHistoryInitial` / `ExamHistoryLoading`: Hiển thị Spinner.
* `ExamHistoryLoaded`: Hiển thị ListView.
* `ExamHistoryEmpty`: Hiển thị thông báo "Bạn chưa làm bài thi nào".
* `ExamHistoryError`: Báo lỗi mạng/Firebase.
* `ExamHistoryDeleting` / `ExamHistoryDeleteSuccess`: Xử lý loading cục bộ khi xóa item, sau đó SnackBar báo thành công.

## 7. Luồng xóa lịch sử (Optimistic Update)
Khi xóa 1 bài làm, thay vì fetch lại toàn bộ lịch sử từ Server gây chậm và tốn Read, ứng dụng thực hiện Xóa trên Firebase -> thành công -> loại bỏ phần tử đó khỏi danh sách trong RAM (`_currentHistories.removeWhere`) -> emit lại state `Loaded`. Tốc độ phản hồi UI cực nhanh.

## 8. Các lưu ý quan trọng
* **Error Handling:** Đã try-catch cẩn thận khi không có mạng, hiển thị lỗi đầy đủ kèm nút Retry.
* **Security:** Lấy ID user từ `FirebaseAuth.instance.currentUser` dưới tầng Service, UI không được phép truyền ID xuống để bảo mật dữ liệu.
* **Performance:** Không dùng thư viện thừa, dùng hàm tự format DateTime nhanh gọn. Tối ưu Rebuild UI bằng BlocConsumer.
