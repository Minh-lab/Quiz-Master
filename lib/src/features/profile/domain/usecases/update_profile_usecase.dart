import 'dart:io';
import 'package:dartz/dartz.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<String, void>> call({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) {
    return repository.updateProfile(
      uid: uid,
      displayName: displayName,
      avatarFile: avatarFile,
    );
  }
}
