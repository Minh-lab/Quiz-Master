import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/change_password_usecase.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase})
      : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());
    
    final result = await changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.fold(
      (error) => emit(ChangePasswordError(errorMessage: error)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
}
