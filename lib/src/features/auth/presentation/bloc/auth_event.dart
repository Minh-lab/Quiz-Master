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
