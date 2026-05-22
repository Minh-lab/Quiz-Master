import 'package:equatable/equatable.dart';

enum AppAuthProvider { google, facebook, email, anonymous }

class UserEntity extends Equatable {
  final String uid; // Firebase UID, là khóa định danh duy nhất
  final String? email; // null nếu là tài khoản Anonymous
  final String?
  displayName; // Tên hiển thị (lấy từ Google/Facebook hoặc tự đặt)
  final String? photoUrl; // Ảnh đại diện (lấy từ Google/Facebook)
  final bool isAnonymous; // true nếu đang ở chế độ khách
  final bool isEmailVerified; // true nếu đã xác minh email
  final AppAuthProvider provider; // Phương thức đăng nhập hiện tại
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isAnonymous,
    required this.isEmailVerified,
    required this.provider,
    this.createdAt,
  });

  bool get isAuthenticated => !isAnonymous;

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    isAnonymous,
    isEmailVerified,
    provider,
    createdAt,
  ];
}
