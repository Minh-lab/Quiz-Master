import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/models/user.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';

abstract class AuthService {
  Future<Either> signInAnonymously();
  Future<Either> linkAnonymousWithGoogle();
  Future<Either> signUpWithEmail(SignupRequest signupRequest);
}
