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
  Future<Either<String, UserEntity>> linkAnonymousWithFacebook() {
    // TODO: implement linkAnonymousWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<String, UserEntity>> linkAnonymousWithGoogle() {
    // TODO: implement linkAnonymousWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<String, void>> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<Either> signInAnonymously() async {
    return await authService.signInAnonymously();
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
  Future<Either<String, UserEntity>> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<Either<String, UserEntity>> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
