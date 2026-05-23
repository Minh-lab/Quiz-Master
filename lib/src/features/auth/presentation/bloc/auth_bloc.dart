import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/AnonymousSignInUsecase.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AnonymoussigninUsecase anonymoussigninUsecase;

  AuthBloc({required this.anonymoussigninUsecase}) : super(AuthInitial()) {
    on<AnonymousSignInRequested>(_onAnonymousSignIn);
    on<SignOutRequested>(_onSignOut);
  }


  Future<void> _onAnonymousSignIn(
    AnonymousSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await anonymoussigninUsecase.call();
    result.fold(
      (error) => emit(AuthError(error.toString())),
      (user) => emit(GuestModeActive(user)),
    );
  }


  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // TODO: gọi signOut usecase khi tạo xong
    emit(AuthSignedOut());
  }
}
