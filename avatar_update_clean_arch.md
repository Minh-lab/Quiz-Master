# Triển khai Upload Avatar chuẩn Clean Architecture

Dưới đây là phương pháp triển khai toàn diện tính năng chọn và tải ảnh đại diện lên Firebase tuân thủ hoàn toàn 3 tầng của Clean Architecture.

## 1. Phân tích luồng xử lý
- **Presentation (UI + State Management)**: `EditProfileScreen` lắng nghe sự kiện của `ProfileCubit`. Khi bấm "Lưu thay đổi", giao diện gọi `profileCubit.updateProfile(uid, name, imageFile)`. Cubit chuyển sang trạng thái `loading` và giao việc cho `Domain`.
- **Domain (UseCase & Repository Contract)**: `UpdateProfileUseCase` nhận yêu cầu, thực thi Business Logic cơ bản và chuyển lệnh xuống Interface `ProfileRepository`.
- **Data (RepositoryImpl & RemoteDataSource)**: `ProfileRepositoryImpl` gọi `ProfileRemoteDataSource`. Tại đây, file ảnh được nén/upload lên `Firebase Storage`, lấy được `downloadURL`, rồi cập nhật vào `Firestore` (`users/{uid}`) kèm tên mới. Đồng thời update luôn profile trong `FirebaseAuth`.
- **Phản hồi ngược**: `Data` trả về thành công -> `UseCase` trả về `Right(void)` -> `ProfileCubit` phát ra state `ProfileUpdateSuccess` -> UI ẩn loading, hiện SnackBar, và reload thông tin `AuthBloc`.

## 2. Danh sách file cần tạo/sửa theo folder hiện tại
Bạn cần bổ sung các cấu trúc thư mục sau vào `lib/src/features/profile/`:
- **Domain:**
  - `domain/repositories/profile_repository.dart`
  - `domain/usecases/update_profile_usecase.dart`
- **Data/Service:**
  - `data/datasources/profile_remote_data_source.dart`
  - `data/repositories/profile_repository_impl.dart`
- **Presentation:**
  - `presentation/cubit/profile_cubit.dart`
  - `presentation/cubit/profile_state.dart`
  - *(Sửa)* `presentation/pages/edit_profile_screen.dart`

---

## 3 & 4. Code đầy đủ: Domain & Cubit/Bloc

### `domain/repositories/profile_repository.dart`
```dart
import 'dart:io';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<String, void>> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  });
}
```

### `domain/usecases/update_profile_usecase.dart`
```dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<String, void>> call({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) {
    return repository.updateProfile(
      uid: uid,
      displayName: displayName,
      avatarFile: avatarFile,
    );
  }
}
```

### `presentation/cubit/profile_state.dart`
```dart
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileUpdateSuccess extends ProfileState {}
class ProfileUpdateFailure extends ProfileState {
  final String errorMessage;
  ProfileUpdateFailure(this.errorMessage);
}
```

### `presentation/cubit/profile_cubit.dart`
```dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({required this.updateProfileUseCase}) : super(ProfileInitial());

  Future<void> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) async {
    emit(ProfileLoading());

    final result = await updateProfileUseCase.call(
      uid: uid,
      displayName: displayName,
      avatarFile: avatarFile,
    );

    result.fold(
      (error) => emit(ProfileUpdateFailure(error)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }
}
```

---

## 5 & 6. Code đầy đủ: Data/Service (Firebase Storage & Firestore)

### `data/datasources/profile_remote_data_source.dart`
```dart
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile({required String uid, String? displayName, File? avatarFile});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) async {
    String? downloadUrl;

    // 1. Upload Firebase Storage
    if (avatarFile != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storageRef = storage.ref().child('users/$uid/avatar/avatar_$timestamp.jpg');
      
      final uploadTask = await storageRef.putFile(avatarFile);
      downloadUrl = await uploadTask.ref.getDownloadURL();
    }

    // 2. Update Firestore
    Map<String, dynamic> updateData = {};
    if (displayName != null && displayName.isNotEmpty) {
      updateData['displayName'] = displayName.trim();
    }
    if (downloadUrl != null) {
      updateData['photoUrl'] = downloadUrl;
    }

    if (updateData.isNotEmpty) {
      await firestore.collection('users').doc(uid).set(
        updateData, 
        SetOptions(merge: true), // Quan trọng: Tránh ghi đè xóa mất dữ liệu cũ
      );
    }

    // 3. Update FirebaseAuth currentUser (để đồng bộ)
    final user = auth.currentUser;
    if (user != null && user.uid == uid) {
      if (displayName != null) await user.updateDisplayName(displayName.trim());
      if (downloadUrl != null) await user.updatePhotoURL(downloadUrl);
    }
  }
}
```

### `data/repositories/profile_repository_impl.dart`
```dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, void>> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) async {
    try {
      await remoteDataSource.updateProfile(
        uid: uid,
        displayName: displayName,
        avatarFile: avatarFile,
      );
      return const Right(null);
    } catch (e) {
      return Left("Lỗi khi cập nhật hồ sơ: $e");
    }
  }
}
```
*(Lưu ý: Bạn nhớ Inject các class này vào Dependency Injection (vd: `get_it` / `sl`) để khởi tạo `ProfileCubit` ở giao diện).*

---

## 7. Code UI hiển thị Avatar sau cập nhật (`edit_profile_screen.dart`)

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Import các file hiện có
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    // Khởi tạo tên cũ
    _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? "";
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Nén ảnh nhẹ
      );
      if (image == null) return; // Người dùng huỷ chọn
      
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      // Bỏ qua lỗi permission denied
    }
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Gọi Cubit
    context.read<ProfileCubit>().updateProfile(
      uid: uid,
      displayName: _nameController.text,
      avatarFile: _image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật hồ sơ thành công!')),
          );
          // Thêm đoạn này để nạp lại AuthBloc toàn app nếu cần
          // context.read<AuthBloc>().add(CheckAuthStatusRequested());
          Navigator.pop(context);
        } else if (state is ProfileUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      _buildAvatarWidget(),
                      // Icon Camera ở góc
                      Positioned(
                        bottom: 0, right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  validator: (val) => val!.isEmpty ? 'Nhập tên' : null,
                ),
                const SizedBox(height: 32),
                // Nút bấm lắng nghe Loading State
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileLoading;
                    return FilledButton(
                      onPressed: isLoading ? null : _onSavePressed,
                      child: isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Lưu thay đổi'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarWidget() {
    // 1. Nếu vừa chọn ảnh từ máy -> Ưu tiên hiện File
    if (_image != null) {
      return CircleAvatar(radius: 50, backgroundImage: FileImage(_image!));
    }
    
    // 2. Nếu đã có URL trên mạng -> Dùng CachedNetworkImage
    final photoUrl = FirebaseAuth.instance.currentUser?.photoURL;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: CachedNetworkImageProvider(photoUrl),
      );
    }
    
    // 3. Mặc định
    return const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50));
  }
}
```

---

## 8. Giải thích chi tiết XFile -> File -> UploadTask -> downloadURL -> Firestore
1. **XFile**: Là định dạng file ảo giúp Flutter code hoạt động trên cả iOS/Android lẫn Web. Khi ta gọi `pickImage()`, package trả về `XFile`.
2. **File (dart:io)**: Các thư viện Native (như Firebase Storage) cần thao tác với đường dẫn thật trên ổ cứng. Ta convert `XFile` sang `File` bằng cách gọi `File(xfile.path)`.
3. **UploadTask**: Hành động `storageRef.putFile(File)` sẽ tạo ra một stream `UploadTask`, đẩy từng byte của ảnh qua môi trường Internet lên cụm máy chủ Google. 
4. **downloadURL**: Sau khi file được đẩy lên xong, Storage sinh ra một URL truy cập dạng HTTPS. Hàm `getDownloadURL()` giúp ta bắt được đường dẫn này.
5. **Firestore & Auth**: Thay vì nhét cục file ảnh lớn vào Database, ta chỉ lưu chuỗi HTTPS đó vào thuộc tính `photoUrl` của `users/{uid}`. App sau này sẽ dùng `CachedNetworkImage(imageUrl: photoUrl)` tải ảnh mượt mà từ chuỗi này.

## 9. Checklist kiểm tra sau khi hoàn thành
- [ ] Khởi tạo (Inject) `ProfileRemoteDataSource`, `ProfileRepository`, `UpdateProfileUseCase`, và `ProfileCubit` vào `GetIt`/`InjectionContainer`.
- [ ] Bọc `BlocProvider<ProfileCubit>` ở màn hình `EditProfileScreen`.
- [ ] Đã khai báo các package `firebase_storage` và `cached_network_image` chưa?
- [ ] Firebase Storage Rules: `allow read, write: if request.auth != null && request.auth.uid == userId;`
- [ ] Thử chọn ảnh nhưng bấm Hủy -> Không báo lỗi.
- [ ] App không bị memory leak (controller được dispose).
- [ ] Ảnh không thay đổi nếu chỉ nhập đổi Tên.
