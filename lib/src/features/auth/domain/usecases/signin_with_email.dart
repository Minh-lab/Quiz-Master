import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class SigninWithEmailUsecase {
  AuthRepository repository;
  SigninWithEmailUsecase({required this.repository});
  Future<Either> call({required SigninRequest signinRequest}) async {
    return await repository.signInWithEmail(signinRequest);
  }
}
