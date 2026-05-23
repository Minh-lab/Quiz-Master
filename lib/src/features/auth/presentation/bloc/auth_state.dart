import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}
class GuestModeActive extends AuthState {             
  final UserEntity guestUser;
  GuestModeActive(this.guestUser);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class PasswordResetEmailSent extends AuthState {}
class AuthSignedOut extends AuthState {}
