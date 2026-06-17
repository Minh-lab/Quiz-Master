import 'dart:io';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<String, void>> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  });
}
