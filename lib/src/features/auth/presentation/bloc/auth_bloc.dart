import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/anonymous_sign_in.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/sign_out.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final SignOutUsecase signOutUsecase;

  AuthBloc({

    required this.signOutUsecase,
  }) : super(AuthInitial()) {

    on<SignOutRequested>(_onSignOut);
    on<UserLoggedIn>((event, emit) => emit(AuthSuccess(event.user)));
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
