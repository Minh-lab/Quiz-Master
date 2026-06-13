# Nhật ký thay đổi Profile Screen

## Những phần đã chỉnh sửa
- **Profile Screen (`profile.dart`)**: Cấu trúc lại giao diện, chia thành các phần rõ ràng:
  - Thông tin cá nhân (Thêm nút Chỉnh sửa hồ sơ).
  - Học tập (Lịch sử làm bài, Sổ lỗi sai, Đề đã lưu, Thống kê học tập).
  - Cài đặt (Chế độ tối, Thông báo, Ngôn ngữ).
  - Tài khoản (Đổi mật khẩu, Đăng xuất).
  - Hỗ trợ (Điều khoản sử dụng, Chính sách bảo mật, Góp ý).
- **Navigation (`app_router.dart`)**: Bổ sung hệ thống định tuyến (routing) cho các màn hình mới thuộc phần Profile để hỗ trợ chuyển trang mượt mà bằng `go_router`.

## Những chức năng đã bổ sung
Đã tạo mới 6 màn hình chức năng với dữ liệu mock (giả lập) theo đúng yêu cầu:
1. **Chỉnh sửa hồ sơ (Edit Profile)**: Giao diện sửa Tên, Số điện thoại, Avatar với biểu mẫu validate đầy đủ.
2. **Đổi mật khẩu (Change Password)**: Form nhập mật khẩu hiện tại, mật khẩu mới, xác nhận với chức năng ẩn/hiện mật khẩu và validate độ dài.
3. **Lịch sử làm bài (Exam History)**: Hiển thị danh sách các đề thi đã làm, thời gian, điểm số đạt được.
4. **Sổ lỗi sai (Wrong Answers)**: Liệt kê các câu hỏi trả lời sai kèm theo đáp án đúng.
5. **Đề đã lưu (Saved Exams)**: Danh sách các đề thi mà người dùng đã đánh dấu lưu lại.
6. **Thống kê học tập (Learning Statistics)**: Bảng thống kê trực quan số lượng bài, tỷ lệ đúng, và thanh tiến trình cho từng môn học.

## Những chức năng đã loại bỏ hoặc thay đổi
- Chuyển mục "Lịch sử làm bài" từ phần "Cài đặt" sang phần "Học tập" cho đúng ngữ cảnh.
- Cập nhật các icon của `ListTile` sử dụng hệ thống Semantic Colors theo Theme thay vì AppColors cố định, nhằm tránh lỗi chìm nền ở chế độ Dark Mode.
- Di chuyển logic các nút bấm điều hướng từ rỗng (empty function) thành các câu lệnh `context.push()` tới màn hình tương ứng.

## Lý do thay đổi
- Sắp xếp lại luồng UI/UX để người dùng có cái nhìn tổng quan, phân bổ chức năng một cách logic (Academic/Settings/Account).
- Đáp ứng việc mở rộng tính năng của ứng dụng (Thống kê, Lưu đề, Lỗi sai).
- Đảm bảo tính nhất quán với Material Design 3 và quy chuẩn thiết kế của toàn app.

## Các file đã sửa
- `lib/src/features/profile/presentation/pages/profile.dart`
- `lib/src/core/router/app_router.dart`

## Các file đã tạo mới
Toàn bộ nằm tại thư mục `lib/src/features/profile/presentation/pages/`:
- `edit_profile_screen.dart`
- `change_password_screen.dart`
- `exam_history_screen.dart`
- `wrong_answers_screen.dart`
- `saved_exams_screen.dart`
- `learning_statistics_screen.dart`

## Hướng dẫn kiểm tra sau khi hoàn thành
1. Chạy lại ứng dụng bằng lệnh thông thường.
2. Điều hướng đến tab **Cá nhân (Profile)**.
3. Kiểm tra xem cấu trúc có đúng như danh sách yêu cầu không.
4. Bấm vào icon **Chỉnh sửa** bên cạnh tên user để mở màn hình *Chỉnh sửa hồ sơ*. Thử bỏ trống ô để xem validation.
5. Cuộn xuống bấm vào các mục **Lịch sử làm bài**, **Sổ lỗi sai**, **Đề đã lưu**, **Thống kê học tập**, **Đổi mật khẩu**. Đảm bảo chuyển trang hoạt động ổn định và UI hiển thị đúng, hỗ trợ cả Dark Mode / Light Mode.
