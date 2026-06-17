import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<String, void>> call({
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
