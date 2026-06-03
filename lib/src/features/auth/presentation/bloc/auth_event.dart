import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';

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

class UserLoggedIn extends AuthEvent {
  final UserEntity user;
  UserLoggedIn(this.user);
}
