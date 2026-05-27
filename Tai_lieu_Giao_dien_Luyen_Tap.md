3.6 Giao diện Luyện tập các kỹ năng (Usecase 06a, 06b, 06c, 06d)

Các giao diện luyện tập kỹ năng cơ bản (Nghe, Nói, Đọc, Viết) được thiết kế đồng nhất với bố cục chung bao gồm: thanh điều hướng bên trái chứa thông tin người dùng và liên kết "Trở lại bài học", phần nội dung học tập ở khu vực trung tâm, và chân trang (footer) chứa thông tin nền tảng.

3.6.1 Giao diện Luyện nghe (Usecase 06a)

Mô tả giao diện:
Khu vực phát âm thanh (Audio Player): Được đặt ở vị trí trung tâm nổi bật nhất, bao gồm thanh tiến trình thời gian (ví dụ: 0:15 / 1:30), nút Phát/Tạm dừng cỡ lớn ở giữa và hai nút tua nhanh/lùi lại 10 giây ở hai bên, giúp người dùng dễ dàng kiểm soát luồng âm thanh.
Khung "Câu hỏi ngữ cảnh": Nằm ngay bên dưới trình phát âm thanh, bao gồm văn bản câu hỏi và danh sách các phương án trả lời dạng trắc nghiệm một lựa chọn (radio button). Các phương án được đóng khung viền chữ nhật, phương án đang được chọn sẽ hiển thị biểu tượng dấu tích và viền đậm màu.
Các nút chức năng phụ trợ: Phía dưới cùng của khung câu hỏi cung cấp một liên kết "Xem bản gỡ băng (Transcript)" ở góc trái để hỗ trợ người học theo dõi nội dung dạng văn bản, và một nút "Tiếp tục nghe" ở góc phải để người dùng xác nhận và tiếp tục bài học.

3.6.2 Giao diện Luyện nói (Usecase 06b)

Mô tả giao diện:
Khung nội dung luyện nói (Câu mẫu): Nằm ở phía trên khu vực trung tâm, hiển thị số thứ tự câu (VD: Câu mẫu #4) kèm biểu tượng chiếc loa để phát âm thanh mẫu. Phía dưới là văn bản câu cần đọc và phần phiên âm quốc tế (IPA) tương ứng nhằm hỗ trợ người dùng phát âm chuẩn xác.
Khung thu âm (Microphone): Nằm ở vị trí trung tâm với một nút biểu tượng micro hình tròn kích thước lớn. Khi đang kích hoạt, hệ thống sẽ hiển thị trạng thái "Đang thu âm..." và hướng dẫn "Nhấn vào micrô để dừng".
Khung phản hồi (Feedback): Nằm phía dưới khu vực thu âm, bao gồm hai thẻ thông tin "Mẹo phát âm" và "AI Feedback", cung cấp các đánh giá tự động từ hệ thống để người dùng cải thiện kỹ năng.
Bảng tiến độ học tập: Được đặt ở cột bên phải giao diện, hiển thị thẻ "TIẾN ĐỘ BÀI HỌC" kèm thanh phần trăm hoàn thành. Bên dưới là nút "Bỏ qua câu này" cho phép người dùng chuyển sang câu tiếp theo mà không cần thu âm.

3.6.3 Giao diện Luyện đọc (Usecase 06c)

Mô tả giao diện:
Giao diện học tập được chia thành hai phần chính: khu vực nội dung bài đọc bên trái và khu vực câu hỏi bên phải.
Khung nội dung bài đọc (Bên trái): Chiếm diện tích lớn nhất, hiển thị toàn bộ văn bản của bài khóa. Khung có nền trắng trống, thiết kế tối giản nhằm tạo không gian đọc thoải mái và tập trung tối đa cho người học.
Bảng tiến độ (Góc trên bên phải): Hiển thị vị trí câu hỏi hiện tại trên tổng số câu hỏi của bài đọc (VD: 1/4 Progress) và số điểm kinh nghiệm (XP) người dùng có thể nhận được.
Khung câu hỏi trắc nghiệm (Bên phải): Hiển thị mục "DẠNG CÂU HỎI", nội dung câu hỏi và danh sách bốn phương án trả lời dạng nút chọn (radio button). 
Nút hành động: Phía dưới danh sách đáp án là nút "Kiểm tra đáp án" màu xanh đậm để hệ thống chấm điểm, bên cạnh là nút có biểu tượng mũi tên để người dùng chuyển nhanh sang câu hỏi kế tiếp.

3.6.4 Giao diện Luyện viết (Usecase 06d)

Mô tả giao diện:
Khung soạn thảo văn bản (Text Editor): Là khu vực trọng tâm để người dùng nhập liệu, được thiết kế với không gian rộng rãi. Phía trên khung nhập liệu tích hợp thanh công cụ định dạng văn bản cơ bản (In đậm, In nghiêng, Danh sách liệt kê) ở góc trái. 
Trình theo dõi và nộp bài: Ở góc trên bên phải của khung soạn thảo là bộ đếm số từ (Words: 0) giúp người dùng kiểm soát độ dài bài viết theo yêu cầu, cùng với nút "Nộp bài" để hoàn tất bài tập.
Khung phản hồi tự động (AI Feedback): Nằm bên dưới trình soạn thảo, cung cấp phản hồi lập tức sau khi người dùng nộp bài thông qua hai thẻ thông tin. Thẻ "Great Usage!" (chữ màu xanh lá) dùng để khích lệ các điểm sáng trong bài viết, và thẻ "AI Suggestion" (chữ màu cam) dùng để đề xuất các cách diễn đạt cải thiện hoặc sửa lỗi ngữ pháp.
