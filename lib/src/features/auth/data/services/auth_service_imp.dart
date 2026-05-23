import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/models/user.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      return Right(UserModel.fromFirebaseUser(credential.user!));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> linkAnonymousWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        throw Exception('Chưa có tài khoản ẩn danh để liên kết');
      }

      final userCredential = await currentUser.linkWithCredential(credential);

      return Right(UserModel.fromFirebaseUser(userCredential.user!));
    } on GoogleSignInException catch (e) {
      throw Exception(e.description ?? 'Đăng nhập Google thất bại');
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Liên kết tài khoản thất bại');
    }
  }

  @override
  Future<Either> signUpWithEmail(SignupRequest signupRequest) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: signupRequest.email,
        password: signupRequest.password,
      );
      User user = credential.user!;
      if (user == null) {
        return Left('Đăng ký không thành công, thử lại sau ít phút!');
      }
      print(user);
      UserModel userModel = UserModel.fromFirebaseUser(user);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());
      return Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
