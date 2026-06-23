# Báo cáo Sửa lỗi Logic Lịch sử làm bài (Duplicate History)

## 1. Phân tích nguyên nhân lỗi
Khi người dùng đang ở `ExamHistoryScreen` và bấm vào nút **"Xem chi tiết"** của một bài làm cũ, hệ thống sẽ mở màn hình `ExamResultScreen` kèm theo dữ liệu `questions` và `userAnswers` đã được giải mã từ lịch sử.

Tuy nhiên, `ExamResultScreen` trước đây chỉ được thiết kế với một mục đích duy nhất là hiển thị kết quả **sau khi nộp bài thi mới**. 
Trong vòng đời (Lifecycle) của `ExamResultScreen`, hàm `_saveHistory()` được gọi mặc định bên trong phương thức `initState()`. 
```dart
  @override
  void initState() {
    super.initState();
    _calculateResult();
    _saveHistory(); // <-- Nguyên nhân gốc rễ
    ...
  }
```
**Hậu quả:** Bất kể người dùng mở `ExamResultScreen` từ hành động Nộp bài mới hay Xem lại lịch sử cũ, hàm `_saveHistory()` đều bị kích hoạt. Nếu mở từ Lịch sử cũ, ứng dụng lấy chính dữ liệu cũ đó đóng gói lại và đẩy lên Firestore như một bản ghi mới hoàn toàn. Điều này làm cho số lượng lịch sử bị nhân đôi (duplicate) một cách vô lý.

## 2. Giải pháp đề xuất và triển khai
Để giải quyết triệt để vấn đề này, chúng ta cần phân tách rõ ràng 2 luồng (Mode) hoạt động của `ExamResultScreen`:
1. **Mode nộp bài mới (New Submission)**: Cần lưu lịch sử lên Database.
2. **Mode xem lại (History Detail)**: Tuyệt đối chỉ hiển thị, không lưu thêm bản ghi.

### Thay đổi đã thực hiện:

#### a. Cập nhật `ExamResultScreen`
- Thêm thuộc tính `final bool isViewingHistory;` vào hàm khởi tạo (constructor), gán giá trị mặc định là `false` để không ảnh hưởng đến luồng Nộp bài cũ.
- Tại `initState()`, thêm cờ điều kiện kiểm tra trước khi gọi hàm lưu:
```dart
  @override
  void initState() {
    super.initState();
    _calculateResult();
    
    // Chỉ lưu History nếu ĐÂY LÀ BÀI THI MỚI
    if (!widget.isViewingHistory) {
      _saveHistory(); 
    }
    ...
  }
```

#### b. Cập nhật Route trong `ExamHistoryScreen`
Khi điều hướng từ Lịch sử sang Kết quả (khi bấm nút "Xem chi tiết"), truyền tham số `isViewingHistory: true` để báo hiệu cho màn hình kết quả biết nó đang ở chế độ Chỉ xem (Read-only):
```dart
  onViewDetail: () {
    if (history.questionsData != null && history.userAnswers != null) {
      ...
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamResultScreen(
            ...
            isViewingHistory: true, // Báo hiệu chế độ xem lịch sử
          ),
        ),
      );
    }
  }
```

## 3. Checklist Test Sau Khi Sửa
Bạn có thể tiến hành kiểm tra theo luồng sau để xác nhận lỗi đã được khắc phục hoàn toàn:

- [ ] **Test Case 1: Nộp bài mới**
  - Làm 1 bài thi mới và ấn nộp.
  - Chờ kết quả hiện ra.
  - Thoát ra ngoài trang Lịch sử -> Xác nhận lịch sử tăng thêm đúng 1 bản ghi mới.
  
- [ ] **Test Case 2: Xem chi tiết lịch sử cũ**
  - Mở trang Lịch sử, chọn 1 bài làm đã có và bấm "Xem chi tiết".
  - Màn hình kết quả hiện ra.
  - Back lại màn hình Lịch sử -> Xác nhận số lượng bản ghi KHÔNG BỊ TĂNG LÊN.

- [ ] **Test Case 3: Spam nút Xem chi tiết**
  - Bấm Xem chi tiết -> Back lại -> Bấm Xem chi tiết -> Back lại (lặp lại 3-4 lần).
  - Xác nhận danh sách Lịch sử vẫn không bị sinh ra các bản ghi trùng lặp.

## 4. Kiến trúc đạt được
Với phương pháp trên, chúng ta đã tận dụng lại thành công UI phức tạp của `ExamResultScreen` cho cả 2 mục đích (Submit và Review) mà không cần phải viết thêm một màn hình `HistoryDetailScreen` riêng biệt chứa các logic trùng lặp, đảm bảo nguyên tắc **DRY** (Don't Repeat Yourself) và giữ cho Clean Architecture được toàn vẹn.
