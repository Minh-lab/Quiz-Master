import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';

class SigninWithGoogleUsecase {
  final AuthRepository repository;

  SigninWithGoogleUsecase({required this.repository});

  Future<Either<dynamic, dynamic>> call() async {
    return await repository.signInWithGoogle();
  }
}
