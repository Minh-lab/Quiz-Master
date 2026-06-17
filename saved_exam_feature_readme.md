# Phân tích chức năng: Lưu đề thi để làm sau (Saved Exams)

## 1. Yêu cầu nghiệp vụ
Cho phép người dùng đánh dấu lưu các đề thi quan tâm để có thể dễ dàng truy cập và làm lại/làm sau.
- Có thể lưu (bookmark) hoặc bỏ lưu (un-bookmark) đề thi từ màn hình danh sách đề (List Exam Screen) và màn hình chi tiết đề (Exam Detail Screen).
- Xem danh sách các đề thi đã lưu tại màn hình `SavedExamsScreen` (truy cập qua tab Cá nhân).
- Quản lý danh sách đã lưu (có thể ấn bỏ lưu trực tiếp từ màn hình danh sách đã lưu).
- Đồng bộ thời gian thực trạng thái lưu bằng optimistic update trên UI.

## 2. Kiến trúc Clean Architecture
Feature được đặt tại: `lib/src/features/saved_exam`

### Domain Layer
Chứa các class abstract, entity và use case không phụ thuộc vào framework.
- **Entity**: `SavedExamEntity` (examId, title, subjectId, duration, totalQuestions, savedAt)
- **Repository**: `SavedExamRepository` (Giao diện abstract)
- **Use Cases**:
  - `SaveExamUseCase`: Lưu đề thi mới vào Firestore.
  - `RemoveSavedExamUseCase`: Xóa đề thi đã lưu.
  - `CheckExamSavedUseCase`: Kiểm tra trạng thái đã lưu hay chưa.
  - `GetSavedExamsUseCase`: Lấy danh sách đề thi đã lưu.

### Data Layer
Giao tiếp với Firebase Firestore, thực hiện parse data.
- **Model**: `SavedExamModel` (kế thừa `SavedExamEntity`, cung cấp hàm `fromFirestore`, `toFirestore`).
- **Data Source**: `SavedExamRemoteDataSourceImpl` thực hiện CRUD trên collection `users/{uid}/saved_exams/{examId}`.
- **Repository Impl**: `SavedExamRepositoryImpl` mapping Data Source sang Domain, xử lý bắt lỗi Exception thành Failure.

### Presentation Layer
Quản lý UI và State Management bằng Cubit (BLoC pattern).
- **Cubits**:
  - `SavedExamCubit`: Quản lý danh sách đề thi đã lưu (Loading, Loaded, Empty, Error, Deleting).
  - `SaveActionCubit`: Quản lý nút bookmark từng đề thi, check trạng thái ban đầu và gọi action lưu/bỏ lưu độc lập (có xử lý optimistic UI tránh delay).
- **Screens & Widgets**:
  - `SavedExamsScreen`: Màn hình danh sách đề đã lưu, có empty state và skeleton loading.
  - `SaveExamButton`: Widget dùng chung (có thể nhúng vào Appbar, Card) để hiển thị và tương tác lưu.
  - Cập nhật `ExamCard` trong ListExamScreen và `AppAppbar` trong ExamDetailScreen để hiển thị nút này.

## 3. Cấu trúc Firestore Schema
Cấu trúc được lưu tại Subcollection của User để tăng tính bảo mật (dùng Security Rule kiểm tra theo uid) và query tốc độ cao:
```
users
 └── {uid}
      └── saved_exams
           └── {examId}
                ├── examId: string
                ├── title: string
                ├── subjectId: string
                ├── duration: number
                ├── totalQuestions: number
                └── savedAt: timestamp
```

## 4. Danh sách các file đã tạo/sửa
**Tạo mới:**
- `lib/src/features/saved_exam/domain/entities/saved_exam_entity.dart`
- `lib/src/features/saved_exam/domain/repositories/saved_exam_repository.dart`
- `lib/src/features/saved_exam/domain/usecases/saved_exam_usecases.dart`
- `lib/src/features/saved_exam/data/models/saved_exam_model.dart`
- `lib/src/features/saved_exam/data/datasources/saved_exam_remote_datasource.dart`
- `lib/src/features/saved_exam/data/repositories/saved_exam_repository_impl.dart`
- `lib/src/features/saved_exam/presentation/cubit/saved_exam_state.dart`
- `lib/src/features/saved_exam/presentation/cubit/saved_exam_cubit.dart`
- `lib/src/features/saved_exam/presentation/cubit/save_action_state.dart`
- `lib/src/features/saved_exam/presentation/cubit/save_action_cubit.dart`
- `lib/src/features/saved_exam/presentation/pages/saved_exams_screen.dart` (Di chuyển và nâng cấp UI)
- `lib/src/features/saved_exam/presentation/widgets/save_exam_button.dart`

**Cập nhật:**
- `lib/src/core/router/app_router.dart`: Sửa đường dẫn import của SavedExamsScreen.
- `lib/app/di/injection_container.dart`: Register toàn bộ dependencies cho SavedExam.
- `lib/src/features/subject_exem/presentation/widgets/exam_card.dart`: Bổ sung param `trailing` Widget.
- `lib/src/features/subject_exem/presentation/exam/pages/list_exam_screen.dart`: Chèn `SaveExamButton` vào ExamCard.
- `lib/src/features/subject_exem/presentation/exam/pages/exam_detail_screen.dart`: Chèn `SaveExamButton` vào AppBar góc phải cạnh Timer.

## 5. Checklist Kiểm tra (QA)
- [x] Nút Bookmark đổi trạng thái Outlined -> Filled ngay lập tức khi ấn (Optimistic Update).
- [x] Hiện Snackbar thông báo sau khi Firebase xử lý xong.
- [x] Mở lại màn hình chi tiết đề kiểm tra xem nút Bookmark có load lại đúng trạng thái đã lưu trước đó không.
- [x] Mở màn hình Cá nhân -> Đề đã lưu kiểm tra xem danh sách hiển thị đủ không.
- [x] Có giao diện Empty State "Bạn chưa lưu đề thi nào" khi xóa hết danh sách.
- [x] Ấn vào 1 item trong Đề đã lưu có điều hướng chính xác vào giao diện Làm bài thi hay không.
- [x] Xoá (Un-bookmark) 1 đề từ màn hình Đề đã lưu, đề đó phải biến mất ngay lập tức.
