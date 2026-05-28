import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/anonymous_sign_in.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/sign_out.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signin_with_email.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signup_with_email.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AnonymousSignInUsecase anonymoussigninUsecase;
  final SignupWithEmailUsecase signupWithEmailUsecase;
  final SigninWithEmailUsecase signinWithEmailUsecase;
  final SignOutUsecase signOutUsecase;

  AuthBloc({
    required this.anonymoussigninUsecase,
    required this.signupWithEmailUsecase,
    required this.signinWithEmailUsecase,
    required this.signOutUsecase,
  }) : super(AuthInitial()) {
    on<AnonymousSignInRequested>(_onAnonymousSignIn);
    on<SignOutRequested>(_onSignOut);
    on<SignupWithEmailRequested>(
      _onSignUpWithEmailRequested,
    ); // TODO: implement>
    on<SigninWithEmailRequested>(
      _onSigninWithEmailRequested,
    ); // TODO: implement>
  }

  Future<void> _onAnonymousSignIn(
    AnonymousSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await anonymoussigninUsecase.call();
    result.fold(
      (error) => emit(AuthError(error.toString())),
      (user) => emit(GuestModeActive(guestUser: user)),
    );
  }

  Future<void> _onSignUpWithEmailRequested(
    SignupWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: implement
    emit(AuthLoading());
    final result = await signupWithEmailUsecase.call(
      signupRequest: event.signupRequest,
    );
    result.fold((error) => emit(AuthError(error.toString())), (user) {
      Future.delayed(Duration(seconds: 2));
      emit(AuthSuccess(user));
    });
  }

  Future<void> _onSigninWithEmailRequested(
    SigninWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: implement
    // print('onSigninWithEmailRequested');
    emit(AuthLoading());
    // Future.delayed(Duration(seconds: 10));

    final result = await signinWithEmailUsecase.call(
      signinRequest: event.signinRequest,
    );
    result.fold((error) => emit(AuthError(error.toString())), (user) {
      Future.delayed(Duration(seconds: 2));
      emit(AuthSuccess(user));
    });
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOutUsecase.call();
    result.fold((l) => emit(AuthError(l.toString())), (r) {
      emit(AuthSignedOut(message: r));
    });
  }
}
