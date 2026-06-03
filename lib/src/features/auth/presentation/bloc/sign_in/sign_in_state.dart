import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}
class SignInLoading extends SignInState {}
class SignInSuccess extends SignInState {
  final UserEntity user;
  SignInSuccess(this.user);
}
class SignInError extends SignInState {
  final String message;
  SignInError(this.message);
}
