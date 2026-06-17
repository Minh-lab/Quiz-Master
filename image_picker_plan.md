# Kế hoạch triển khai Image Picker

## 1. Mục tiêu
Hiện thực hóa chức năng chọn ảnh từ thư viện của điện thoại để làm ảnh đại diện trong màn hình `EditProfileScreen`. Đồng thời, tài liệu này sẽ giải thích các kiến thức liên quan đến đoạn code được sử dụng.

## 2. Các bước thực hiện chi tiết

### 2.1. Cài đặt thư viện image_picker
Đây là plugin chính thức từ đội ngũ Flutter, hỗ trợ dễ dàng việc lấy ảnh từ Camera hoặc Thư viện của thiết bị. Bạn cần mở terminal và chạy lệnh:
```bash
flutter pub add image_picker
```

### 2.2. Cập nhật cấu hình quyền truy cập của hệ điều hành
Để ứng dụng có thể đọc được ảnh từ thiết bị, chúng ta đôi khi cần khai báo quyền tuỳ thuộc vào nền tảng.
- **Đối với iOS**: Bạn cần mở file `ios/Runner/Info.plist` và thêm từ khoá `NSPhotoLibraryUsageDescription` để khai báo lý do ứng dụng cần truy cập thư viện ảnh, nhằm vượt qua kiểm duyệt của Apple.
- **Đối với Android**: Từ Android 13 trở lên, nếu sử dụng `image_picker` phiên bản mới, nó đã tích hợp sẵn tính năng Photo Picker an toàn mà không cần cấp quyền. Nếu thiết bị cũ hơn hoặc cần đọc file trực tiếp, bạn khai báo quyền `READ_EXTERNAL_STORAGE` hoặc `READ_MEDIA_IMAGES` trong `AndroidManifest.xml`.

### 2.3. Chỉnh sửa logic trong file EditProfileScreen
- Khai báo thêm hai thư viện cần thiết ở đầu file: `dart:io` để thao tác với `File`, và `image_picker` để lấy chức năng chọn ảnh.
- Trong class `_EditProfileScreenState`, khai báo thêm một biến: `File? _selectedImage`. Biến này dùng để lưu trữ file ảnh sau khi người dùng đã chọn thành công.
- Viết một hàm bất đồng bộ `_pickImage()`. Trong hàm này, chúng ta khởi tạo đối tượng `ImagePicker`, rồi gọi phương thức `pickImage` với tham số nguồn là `ImageSource.gallery` để mở thư viện ảnh.
- Nếu quá trình chọn ảnh thành công người dùng không bấm huỷ, kết quả trả về sẽ là một `XFile`. Ta lấy đường dẫn của `XFile` này, tạo thành một đối tượng `File` và gán nó vào biến `_selectedImage` thông qua lệnh `setState()` để báo cho giao diện biết cần phải cập nhật.

### 2.4. Chỉnh sửa giao diện hiển thị
- Trong phần xây dựng widget `Stack` của hình đại diện `CircleAvatar`, chúng ta cần thêm điều kiện để hiển thị.
- Kiểm tra biến `_selectedImage`. Nếu biến này khác `null` tức là người dùng đã chọn ảnh, chúng ta thêm thuộc tính `backgroundImage` cho `CircleAvatar` bằng cách sử dụng `FileImage(_selectedImage!)`. Nếu biến là `null`, chúng ta vẫn hiển thị màu nền và biểu tượng icon mặc định như hiện tại.
- Để bắt sự kiện click, chúng ta bọc nút camera hoặc toàn bộ khối avatar bằng widget `GestureDetector` hoặc `InkWell`. Trong sự kiện `onTap` của widget đó, chúng ta chỉ cần gọi đến hàm `_pickImage()` vừa tạo.

### 2.5. Xử lý logic lưu thông tin (Save Changes)
Khi người dùng bấm nút "Lưu thay đổi", chúng ta cần thực hiện các bước sau để lưu hình ảnh thực sự lên máy chủ và cập nhật tài khoản:
- **Kiểm tra dữ liệu đầu vào:** Xác nhận xem người dùng có chọn ảnh mới (`_image != null`) hay chỉ đổi tên.
- **Tải ảnh lên Storage (Máy chủ lưu trữ):** Do file ảnh chỉ tồn tại tạm thời trên điện thoại, ta cần upload `File _image` lên Firebase Storage hoặc máy chủ backend của bạn. Sau khi upload thành công, dịch vụ này sẽ trả về một đường link URL ảnh public (Download URL).
- **Cập nhật dữ liệu người dùng:** Gọi API backend hoặc hàm cập nhật của Firebase truyền vào URL ảnh vừa lấy được cùng với Họ Tên mới từ `_nameController`.
- **Cập nhật State Management:** Gửi một Event (ví dụ: `ProfileUpdatedEvent`) vào `AuthBloc` hoặc Reload lại dữ liệu để cập nhật thông tin User trên toàn bộ hệ thống ứng dụng, giúp các màn hình khác tự động hiển thị ảnh và tên mới.

## 3. Kiến thức chuyên sâu về đoạn code

### 3.1. Sự khác biệt giữa XFile và File
Hàm chọn ảnh trả về dữ liệu dưới dạng `XFile`, viết tắt của *Cross-file*. Đây là một định dạng bao bọc giúp hỗ trợ đa nền tảng bao gồm cả ứng dụng trên Web. Tuy nhiên, đối với ứng dụng di động Native như Android hay iOS, để hiển thị ảnh ra ngoài màn hình hoặc thao tác gửi lên server qua API, chúng ta bắt buộc phải chuyển `XFile` về dạng `File` của thư viện `dart:io` bằng cách lấy thuộc tính `path` của nó.

### 3.2. Bất đồng bộ trong việc chọn ảnh
Hành động ứng dụng của bạn yêu cầu hệ điều hành mở bộ sưu tập ảnh là một tiến trình xảy ra ngoài luồng hoạt động chính của UI. Ứng dụng phải chờ đợi kết quả phản hồi (người dùng đang tìm ảnh, lựa chọn ảnh hoặc bấm hủy thẻ tag). Việc sử dụng từ khoá `async` cho hàm và từ khoá `await` trước câu lệnh `pickImage` giúp ứng dụng có thể tạm dừng việc thực thi dòng code đó để nhường tài nguyên, không gây tình trạng treo (freeze) màn hình trong lúc người dùng đang lựa chọn ảnh.

### 3.3. Quản lý trạng thái (State Management)
Để thể hiện được bức ảnh lên màn hình, thay vì phải tải lại (reload) toàn bộ trang, chúng ta ứng dụng nguyên lý của `StatefulWidget`. Khi bạn gán `_selectedImage = File(image.path)` bên trong khối lệnh `setState()`, nó sẽ tự động phát ra tín hiệu thông báo rằng trạng thái nội bộ của màn hình đã bị thay đổi. Lúc này framework Flutter sẽ gọi lại hàm `build()`, nó đọc được giá trị mới của `_selectedImage` và thể hiện bức ảnh mới lên màn hình mà không làm mất đi các dữ liệu đang nhập dở dang ở chu kỳ `TextFormField` bên dưới.

### 3.4. Logic lưu trữ đám mây (Cloud Storage)
Việc lưu trữ trực tiếp file ảnh dưới dạng nhị phân (hoặc Base64) vào cơ sở dữ liệu (Database) thường không được khuyến khích vì làm phình to kích thước bản ghi và giảm hiệu suất truy vấn. Thực tiễn tốt nhất (Best Practice) là tải file vật lý lên một dịch vụ Storage (như Firebase Cloud Storage, AWS S3), sau đó lấy đường dẫn URL dạng văn bản (`String`), và chỉ lưu chuỗi URL này vào Database của User. Khi cần hiển thị, ứng dụng sẽ dùng `NetworkImage(url)` để load ảnh từ server về.
