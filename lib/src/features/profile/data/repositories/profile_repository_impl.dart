import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, void>> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) async {
    try {
      await remoteDataSource.updateProfile(
        uid: uid,
        displayName: displayName,
        avatarFile: avatarFile,
      );
      return const Right(null);
    } catch (e) {
      return Left("Lỗi khi cập nhật hồ sơ: $e");
    }
  }
}
