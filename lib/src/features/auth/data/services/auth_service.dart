import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/models/user.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';

abstract class AuthService {


  Future<Either> signUpWithEmail(SignupRequest signupRequest);
  Future<Either> signInWithEmail(SigninRequest signinRequest);
  Future<Either> signInWithGoogle();

  Future<Either> signOut();
}
