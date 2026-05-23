import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class SignupWithEmailUsecase {
  AuthRepository repository;
  SignupWithEmailUsecase({required this.repository});

  Future<Either> call({required SignupRequest signupRequest}) =>
      repository.signUpWithEmail(signupRequest);
}
