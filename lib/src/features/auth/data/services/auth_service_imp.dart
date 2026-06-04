import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/models/user.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<dynamic, dynamic>> signInWithEmail(
    SigninRequest signinRequest,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: signinRequest.email,
        password: signinRequest.password,
      );
      final userCredential = credential.user;
      final userFirestore = await _firestore
          .collection('users')
          .doc(userCredential!.uid)
          .get();
      final userData = userFirestore.data();
      UserModel user = UserModel.fromJson(userData!);
      ();
      print(user.toEntity);
      return Right(user.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> signOut() async {
    // TODO: implement signOut
    try {
      await _firebaseAuth.signOut();
      print('Signout Request service');
      return Right('Signout successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<dynamic, dynamic>> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '795544707095-rfdd4gb4teugpt0hjjkch5cmjlgc78k5.apps.googleusercontent.com',
      );

      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        return Left('Không lấy được thông tin người dùng từ Firebase.');
      }

      final userModel = UserModel.fromFirebaseUser(user);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson(), SetOptions(merge: true));

      return Right(userModel.toEntity());
    } catch (e) {
      return Left('Đăng nhập Google thất bại: $e');
    }
  }
}
