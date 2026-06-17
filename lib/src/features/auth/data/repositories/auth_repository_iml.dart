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
  // TODO: implement authStateChanges
  Stream<UserEntity?> get authStateChanges => throw UnimplementedError();

  @override
  Future<UserEntity?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either> signInWithEmail(SigninRequest signinRequest) async {
    // TODO: implement signInWithEmail
    return await authService.signInWithEmail(signinRequest);
  }

  @override
  Future<Either<dynamic, dynamic>> signUpWithEmail(
    SignupRequest signupRequest,
  ) {
    // TODO: implement signUpWithEmail
    return authService.signUpWithEmail(signupRequest);
  }

  @override
  Future<Either> signOut() async {
    // TODO: implement signOut
    return await authService.signOut();
  }

  @override
  Future<Either<String, void>> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<dynamic, dynamic>> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<dynamic, dynamic>> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    return authService.signInWithGoogle();
  }

  @override
  Future<Either<String, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    // AuthService trả về Either, ta ép kiểu sang Either<String, void>
    return result.fold(
      (l) => Left(l.toString()),
      (r) => const Right(null),
    );
  }
}
