import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({required this.updateProfileUseCase}) : super(ProfileInitial());

  Future<void> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) async {
    emit(ProfileLoading());

    final result = await updateProfileUseCase.call(
      uid: uid,
      displayName: displayName,
      avatarFile: avatarFile,
    );

    result.fold(
      (error) => emit(ProfileUpdateFailure(error)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }
}
