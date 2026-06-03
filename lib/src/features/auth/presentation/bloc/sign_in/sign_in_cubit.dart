import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signin_with_email.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signin_with_google.dart';
import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SigninWithEmailUsecase signinWithEmailUsecase;
  final SigninWithGoogleUsecase signinWithGoogleUsecase;

  SignInCubit({
    required this.signinWithEmailUsecase,
    required this.signinWithGoogleUsecase,
  }) : super(SignInInitial());

  Future<void> signIn(SigninRequest request) async {
    emit(SignInLoading());
    final result = await signinWithEmailUsecase.call(signinRequest: request);
    result.fold(
      (error) => emit(SignInError(error.toString())),
      (user) => emit(SignInSuccess(user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SignInLoading());
    final result = await signinWithGoogleUsecase.call();
    result.fold(
      (error) => emit(SignInError(error.toString())),
      (user) => emit(SignInSuccess(user)),
    );
  }
}
