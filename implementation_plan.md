# Kế hoạch Triển khai Màn hình Làm Bài Thi (Exam Detail Screen)

Dựa trên thiết kế UI vô cùng hiện đại và rõ ràng mà bạn vừa cung cấp, mình đã phân tích và vạch ra kế hoạch chi tiết để "chuyển mã" bức ảnh này thành code Flutter một cách hoàn hảo nhất.

## 1. Mục tiêu (Goal)
Hoàn thiện giao diện màn hình `ExamDetailScreen` (hiện đang trống) giống 100% bản thiết kế, bao gồm các thành phần: thanh đếm ngược, thanh tiến trình, dải số câu hỏi, thẻ câu hỏi chi tiết và thanh điều hướng đáy.

---

## 2. Phân rã Cấu trúc UI (Component Breakdown)

Màn hình sẽ được chia thành các Widget nhỏ để dễ quản lý, nằm trong file `exam_detail_screen.dart`:

### 2.1. `_buildAppBar()`
- Sử dụng `AppBar` tiêu chuẩn hoặc tuỳ chỉnh.
- **Trái:** Nút Back mũi tên và Tiêu đề `ĐỀ THI THPT QUỐC GIA 2025` (chữ in hoa, màu xanh đậm/đen).
- **Phải:** Một `Row` chứa `Icon(Icons.access_time)` và Text `54:12` hiển thị bộ đếm ngược.

### 2.2. `_buildProgressBar()`
- Một khối `Column` gồm 2 phần:
  - Text: `Câu 1/50` (chữ nhỏ, màu xám/đen).
  - Thanh `LinearProgressIndicator`: Bo góc tròn (`borderRadius`), phần đã làm màu Xanh (`AppColors.primary`), phần chưa làm màu Xám nhạt.

### 2.3. `_buildQuestionNavigator()`
- Một `SizedBox` có chiều cao cố định chứa `ListView.builder` cuộn ngang (`scrollDirection: Axis.horizontal`).
- Các nút số câu hỏi (1, 2, 3...):
  - **Câu đang chọn:** Hình tròn nền Xanh (`AppColors.primary`), chữ Trắng.
  - **Câu bình thường:** Hình tròn viền xám mờ, nền trắng, chữ đen.
  - *(Lưu ý: Thay vì hiển thị dấu `...` cố định, mình sẽ làm thành danh sách cuộn mượt mà từ 1 đến 50, chuẩn UX mobile hơn).*

### 2.4. `_buildQuestionCard()`
Đây là phần trung tâm, được bọc trong một `Container` có viền bo góc tròn to (khoảng `radius 16` hoặc `20`) và đường viền (`border`) màu xám cực nhạt.
- **Header Thẻ:** Một `Row` chứa Text `Câu 1:` (màu Xanh) và một Badge `0.25 điểm` (nền Cam nhạt, chữ đen).
- **Nội dung câu hỏi:** Text nội dung (`Đạo hàm của hàm số...`).
- **Danh sách Đáp án (A, B, C, D):**
  - Sử dụng `ListView.builder` hoặc `Column`.
  - Mỗi đáp án là một thẻ `Container` bo góc, có viền xám nhạt.
  - Điểm nhấn: Chữ A, B, C, D được bọc trong một hình tròn nhỏ có nền xanh nhạt (`blue.withOpacity(0.1)`). Kế bên là nội dung đáp án (`1`).

### 2.5. `_buildBottomNav()`
Thanh công cụ dính ở đáy màn hình (`bottomNavigationBar` của `Scaffold`).
- Chứa 3 nút bấm phân bổ đều hoặc dùng `Row` với `MainAxisAlignment.spaceBetween`:
  - **TRƯỚC:** `OutlinedButton` (viền xám nhạt, chữ đen).
  - **NỘP BÀI:** `OutlinedButton` (viền xám nhạt, chữ đen).
  - **SAU:** `ElevatedButton` (Nền xanh đặc, chữ trắng).

---

## 3. Quản lý Trạng thái Tạm thời (UI State)
Để màn hình có thể tương tác (bấm qua lại), mình sẽ chuyển `ExamDetailScreen` thành `StatefulWidget` và thêm các biến:
- `int currentQuestionIndex = 0;` (Lưu vị trí câu hiện tại).
- `Map<int, int> selectedAnswers = {};` (Lưu đáp án đã chọn để đổi màu khi người dùng tick vào).

---

> [!IMPORTANT]
> ## User Review Required
> Bạn hãy xem qua cấu trúc phân rã giao diện phía trên. Việc phân tách thẻ `QuestionCard` ra một khối bo góc riêng biệt với nền trắng là một điểm sáng trong thiết kế này, giúp người dùng tập trung cực tốt.
> 
> Nếu bạn thấy mọi thứ đã chuẩn, hãy Approve (Phản hồi **"Đồng ý"**), mình sẽ bắt tay vào code giao diện này ngay lập tức!
