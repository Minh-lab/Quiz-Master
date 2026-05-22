import 'package:quiz_mater_apllication/src/features/auth/data/models/user.dart';

abstract class AuthService {
  Future<UserModel> signInAnonymously();
  Future<UserModel> linkAnonymousWithGoogle();
}