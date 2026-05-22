import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  // Lấy user hiện tại (null nếu chưa đăng nhập)
  Future<UserEntity?> getCurrentUser();

  // Stream theo dõi trạng thái đăng nhập thay đổi theo thời gian thực
  Stream<UserEntity?> get authStateChanges;

  // Đăng nhập bằng Email & Password
  Future<Either<String, UserEntity>> signInWithEmail(
    String email,
    String password,
  );

  Future<Either<String, UserEntity>> signInWithGoogle();

  Future<Either<String, UserEntity>> signInWithFacebook();

  Future<Either<String, UserEntity>> signInAnonymously();

  Future<Either<String, UserEntity>> linkAnonymousWithGoogle();

  Future<Either<String, UserEntity>> linkAnonymousWithFacebook();

  Future<Either<String, void>> sendPasswordResetEmail(String email);

  Future<void> signOut();
}
