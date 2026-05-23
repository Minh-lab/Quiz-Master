import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class AnonymoussigninUsecase {
  AuthRepository authRepository;
  AnonymoussigninUsecase(this.authRepository);

  Future<Either> call() async {
    return await authRepository.signInAnonymously();
  }
}
