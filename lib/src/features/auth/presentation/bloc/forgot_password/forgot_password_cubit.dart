import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/send_password_reset_email.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;

  ForgotPasswordCubit(this.sendPasswordResetEmailUseCase) : super(ForgotPasswordInitial());

  Future<void> sendResetEmail(String email) async {
    emit(ForgotPasswordLoading());
    final result = await sendPasswordResetEmailUseCase.call(email);
    result.fold(
      (error) => emit(ForgotPasswordError(error)),
      (_) => emit(ForgotPasswordSuccess('Link khôi phục mật khẩu đã được gửi đến email của bạn, vui lòng kiểm tra hộp thư đến/hộp thư rác.')),
    );
  }
}
