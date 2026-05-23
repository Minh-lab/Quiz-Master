import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  // Lấy user hiện tại (null nếu chưa đăng nhập)
  Future<UserEntity?> getCurrentUser();

  // Stream theo dõi trạng thái đăng nhập thay đổi theo thời gian thực
  Stream<UserEntity?> get authStateChanges;

  // Đăng nhập bằng Email & Password
  Future<Either> signInWithEmail(SigninRequest signinRequest);
  Future<Either> signUpWithEmail(SignupRequest signupRequest);

  Future<Either> signInWithGoogle();

  Future<Either> signInWithFacebook();

  Future<Either> signInAnonymously();

  Future<Either> linkAnonymousWithGoogle();

  Future<Either> linkAnonymousWithFacebook();

  Future<Either<String, void>> sendPasswordResetEmail(String email);

  Future<void> signOut();
}
