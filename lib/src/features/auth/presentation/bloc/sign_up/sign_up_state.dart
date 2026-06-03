import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}
class SignUpSuccess extends SignUpState {
  final UserEntity user;
  SignUpSuccess(this.user);
}
class SignUpError extends SignUpState {
  final String message;
  SignUpError(this.message);
}
