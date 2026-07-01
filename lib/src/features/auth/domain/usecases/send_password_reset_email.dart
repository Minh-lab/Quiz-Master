import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase(this.repository);

  Future<Either<String, void>> call(String email) {
    return repository.sendPasswordResetEmail(email);
  }
}
