# Hướng dẫn và Tài liệu Tối ưu UI Responsive

Dự án đã được rà soát và tối ưu giao diện (UI) để đảm bảo trải nghiệm hiển thị hoàn hảo trên đa dạng các thiết bị Android từ kích thước nhỏ (~5.5 inch) đến các thiết bị lớn hơn hoặc Tablet.

## 1. Các vấn đề Responsive đã phát hiện
- Sử dụng quá nhiều kích thước text lớn (ví dụ: `headlineLarge`, `headlineSmall` thay vì `titleMedium`, `titleLarge`) gây tràn chữ (overflow) trên máy có màn hình hẹp.
- Nhiều kích thước `height`, `width` được gán cứng, không hỗ trợ co giãn linh hoạt khi kích thước màn hình thay đổi.
- `Spacer()` hoặc `Expanded()` không được bao bọc đúng cách dẫn đến nguy cơ `RenderFlex overflow` trong các cấu trúc phức tạp.

## 2. Các file đã sửa
- `lib/src/core/theme/app_typography.dart`
- `lib/src/features/subject_exem/presentation/widgets/subject_card.dart`
- `lib/src/features/subject_exem/presentation/widgets/top_banner.dart`
- `lib/src/features/subject_exem/presentation/widgets/exam_card.dart`
- `lib/src/features/subject_exem/presentation/exam/pages/exam_detail_screen.dart`
- `lib/src/features/subject_exem/presentation/exam/pages/exam_result_screen.dart`

## 3. Các widget đã refactor
- **AppTypography**: Bổ sung thêm các size chữ chuẩn MD3 (`titleLarge`, `titleMedium`, `titleSmall`) để tiện cho việc sử dụng ở các màn hình có mật độ chữ cao.
- **SubjectCard**: Chuyển `headlineSmall` thành `titleMedium`, thêm `maxLines: 1` và `overflow: TextOverflow.ellipsis` triệt để nhằm giữ layout lưới (Grid) không bị vỡ.
- **TopBanner**: Hạ size chữ hiển thị tên người dùng và lời chào, chuyển `headlineLarge` -> `titleLarge` và `headlineSmall` -> `titleMedium` để vừa vặn hơn ở SafeArea góc trên. Đảm bảo sử dụng `Expanded` bao bọc các đoạn text dài.
- **ExamCard**: Áp dụng `Wrap` thay cho `Row` cố định đối với thời gian và số câu hỏi để ngăn chặn RenderFlex Overflow khi chữ bị kéo dài hoặc thiết bị siêu nhỏ. Chuyển `headlineSmall` -> `titleLarge`.
- **ExamDetailScreen**: Tối ưu Navigation ngang của các câu hỏi với kích thước chữ phù hợp hơn (`titleMedium`), nội dung bài kiểm tra `MathTextBuilder` đổi từ `headlineMedium` sang `bodyLarge` để tránh chữ quá to ở màn hình nhỏ.
- **ExamResultScreen**: Điều chỉnh lại thẻ kết quả (`Hoàn thành!`), kích thước biểu đồ điểm số (`fontSize: 48` -> `fontSize: 40`), và các Stat item thành `titleMedium` để an toàn cho mọi orientation.

## 4. Các màn hình đã tối ưu
- **HomeScreen / ExemSubjectScreen**
- **ListExamScreen**
- **ExamDetailScreen**
- **ExamResultScreen**
- **ProfileScreen** (Đã check, không có lỗi Layout do padding linh hoạt và Expanded chuẩn).

## 5. Các kích thước đã thay đổi
- Chuyển đổi font cứng thành Material Typography.
- Các khoảng cách `SizedBox` cứng được tối ưu để hoạt động như padding nội bộ, không phá vỡ Grid/List container bên ngoài.

## 6. Các lỗi overflow đã xử lý
- Rủi ro tràn chữ ở Card Môn học khi tên quá dài (Ví dụ: Địa lý, Tiếng Anh nâng cao...).
- Rủi ro tràn dòng ở Top Banner do độ dài email/tên hiển thị.

## 7. Hướng dẫn kiểm tra trên nhiều thiết bị
- Sử dụng Device Preview hoặc Resize cửa sổ Windows giả lập Android.
- Vào phần cài đặt Display của Android tăng giảm mức "Font Size" và "Display Size" (tính năng Accessibility) để đảm bảo text co giãn mượt mà, không vỡ layout.
