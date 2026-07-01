import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service_imp.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryIml extends AuthRepository {
  AuthService authService = AuthServiceImpl();
  AuthRepositoryIml({required this.authService});
  
  @override
  Stream<UserEntity?> get authStateChanges => throw UnimplementedError();

  @override
  Future<UserEntity?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either> signInWithEmail(SigninRequest signinRequest) async {
    return await authService.signInWithEmail(signinRequest);
  }

  @override
  Future<Either<dynamic, dynamic>> signUpWithEmail(
    SignupRequest signupRequest,
  ) {
    return authService.signUpWithEmail(signupRequest);
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await authService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> sendPasswordResetEmail(String email) async {
    try {
      await authService.sendPasswordResetEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> signInWithGoogle() {
    return authService.signInWithGoogle();
  }
  
  @override
  Future<Either<dynamic, dynamic>> signInWithFacebook() {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final result = await authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return result.fold(
        (l) => Left(l.toString()),
        (r) => const Right(null),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
