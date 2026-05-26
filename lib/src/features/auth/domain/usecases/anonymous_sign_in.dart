import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class AnonymousSignInUsecase {
  AuthRepository repository;
  AnonymousSignInUsecase({required this.repository});

  Future<Either> call() async {
    return await repository.signInAnonymously();
  }
}
