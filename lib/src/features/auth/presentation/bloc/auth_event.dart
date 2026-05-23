import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';

abstract class AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class FacebookSignInRequested extends AuthEvent {}

class AnonymousSignInRequested extends AuthEvent {}

class LinkWithGoogleRequested extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  ResetPasswordRequested(this.email);
}

class SignOutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

class SigninWithEmailRequested extends AuthEvent {
  SigninRequest signinRequest;
  SigninWithEmailRequested({required this.signinRequest});
}

class SignupWithEmailRequested extends AuthEvent {
  SignupRequest signupRequest;
  SignupWithEmailRequested({required this.signupRequest});
}
