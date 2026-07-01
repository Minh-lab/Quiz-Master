import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signup_with_email.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signin_with_google.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignupWithEmailUsecase signupWithEmailUsecase;
  final SigninWithGoogleUsecase signinWithGoogleUsecase;

  SignUpCubit({
    required this.signupWithEmailUsecase,
    required this.signinWithGoogleUsecase,
  }) : super(SignUpInitial());

  Future<void> signUp(SignupRequest request) async {
    emit(SignUpLoading());
    final result = await signupWithEmailUsecase.call(signupRequest: request);
    result.fold(
      (error) => emit(SignUpError(error.toString())),
      (user) => emit(SignUpSuccess(user)),
    );
  }

  Future<void> signUpWithGoogle() async {
    emit(SignUpLoading());
    final result = await signinWithGoogleUsecase.call();
    result.fold(
      (error) => emit(SignUpError(error.toString())),
      (user) => emit(SignUpSuccess(user)),
    );
  }
}
