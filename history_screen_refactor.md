# Refactor Màn hình Lịch sử làm bài (Exam History Screen)

Tài liệu này ghi lại quá trình và chi tiết các công việc đã thực hiện để refactor lại thiết kế của `Exam History Screen` và `History Card`, nhằm khắc phục các lỗi UI/UX và tối ưu hiển thị trên nhiều kích thước màn hình.

## 1. Phân tích vấn đề UI hiện tại
Dựa trên hình ảnh và báo cáo lỗi từ người dùng, màn hình Lịch sử làm bài cũ gặp các vấn đề sau:
- **Lỗi RenderFlex overflow**: Xảy ra ở cạnh phải màn hình do cụm thông tin Metadata (Thời gian, Số câu, Ngày làm bài) được nhồi nhét vào một thẻ `Row` cứng nhắc, không thể tự xuống dòng khi thiếu không gian.
- **Nút "Xóa"**: Trước đây chỉ là một IconButton đơn lẻ, kích thước touch target nhỏ và gây mất cân đối cho giao diện. Nút "Xem chi tiết" chiếm quá nhiều không gian.
- **Điểm số đè lên tiêu đề**: Tiêu đề và badge điểm số không được giới hạn không gian hợp lý, gây ra nguy cơ đè chữ.
- **Hierarchy (Phân cấp thông tin) chưa rõ ràng**: Các thông tin như đúng/sai/bỏ qua chỉ hiển thị thành một text đơn giản, thiếu tính trực quan (semantic colors).
- **Code Bloat**: Toàn bộ UI của card nằm trực tiếp trong hàm `build` của màn hình, làm cho `exam_history_screen.dart` dài và khó bảo trì.

## 2. Thiết kế History Card mới (Hierarchy & Layout)
Thiết kế mới được chia thành 5 hàng (Rows) riêng biệt theo thứ tự quan trọng từ trên xuống dưới:

* **Hàng 1 (Title & Badge):** Tên đề thi (tối đa 2 dòng, tự động cắt chữ `ellipsis`) nằm bên trái nhờ thẻ `Expanded`, bên phải là Badge điểm số bo góc có background nổi bật.
* **Hàng 2 (Subject):** Tên môn học hiển thị nhỏ màu xám nhạt (`onSurfaceVariant`) để bổ sung context.
* **Hàng 3 (Metadata):** Tổng thời gian làm bài, tỷ lệ câu đúng/tổng, ngày giờ nộp bài. Áp dụng thẻ `Wrap` thay cho `Row` để tự động đẩy cụm thông tin thừa xuống dòng dưới nếu màn hình hẹp.
* **Hàng 4 (Statistics):** Thống kê chi tiết số câu Đúng / Sai / Bỏ qua. Hiển thị dưới dạng khối thông tin `label` + `number` với màu sắc ngữ nghĩa (xanh lá, đỏ, vàng cam) giúp mắt người dùng dễ dàng nhận diện ngay lập tức.
* **Hàng 5 (Action Buttons):** 
  - Nút "Xem chi tiết" là Primary Action (chiếm tỷ lệ 2 phần).
  - Nút "Xóa" là Secondary/Destructive Action (chiếm tỷ lệ 1 phần), nay là một `OutlinedButton.icon` có viền đỏ và chữ, dễ chạm hơn.

## 3. Các Widget đã được tách ra
Để tuân thủ Clean UI và nguyên tắc Single Responsibility, toàn bộ khối Card đã được dời sang file mới `history_card.dart` tại thư mục `widgets`. Các widget con được tách nhỏ bao gồm:
1. `HistoryCard`: Container chính định hình Card.
2. `HistoryScoreBadge`: Khối bo góc chứa điểm số.
3. `HistoryMetadataRow`: Hiển thị Thời gian, Tổng câu, Ngày tháng (sử dụng Wrap).
4. `HistoryStatisticsRow`: Hiển thị số liệu Đúng/Sai/Bỏ qua dạng cột màu sắc.
5. `HistoryActionRow`: Chứa cụm 2 nút bấm Xem chi tiết và Xóa (sử dụng Expanded flex: 2 và flex: 1).

## 4. Các cải tiến Responsive và Xử lý Lỗi
- **Khắc phục Overflow**: Sử dụng `Expanded` cho Title, `Wrap` cho Metadata, và `FittedBox` cho nhãn của nút Xóa. Đảm bảo trên các màn hình nhỏ (như 5.5 inch) giao diện sẽ tự động co giãn thay vì báo lỗi.
- **Tránh hard-code kích thước**: Toàn bộ UI hiện tại điều khiển layout bằng `Expanded`, `Flex`, padding động và `Wrap`. Không có bất kỳ thành phần nào bị gán cứng `width` hay `height`.
- **Loading State cho nút Xóa**: Khi người dùng ấn nút Xóa và chờ phản hồi từ Server, Icon thùng rác sẽ chuyển thành `CircularProgressIndicator` siêu nhỏ ngay bên trong nút, tạo phản hồi UX rất tốt.
- **Empty State & Refresh**: Đã tích hợp sẵn `RefreshIndicator` để Pull-to-refresh và giao diện `EmptyState` thân thiện khi chưa có lịch sử thi nào.

## Tổng kết
File `exam_history_screen.dart` giờ đây cực kỳ gọn gàng và dễ đọc. Toàn bộ logic giao diện phức tạp đã được cô lập an toàn trong `history_card.dart`, mang lại một History Card mang chuẩn mực thiết kế ứng dụng Production (như Duolingo hay Quizlet).
