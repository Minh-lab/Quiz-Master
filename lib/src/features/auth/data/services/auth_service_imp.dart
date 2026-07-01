import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return const Left('Email này đã được đăng ký.');
      } else if (e.code == 'invalid-email') {
        return const Left('Email không hợp lệ.');
      } else if (e.code == 'weak-password') {
        return const Left('Mật khẩu quá yếu. Vui lòng sử dụng mật khẩu mạnh hơn.');
      } else if (e.code == 'network-request-failed') {
        return const Left('Không có kết nối mạng. Vui lòng kiểm tra lại.');
      }
      return Left('Lỗi đăng ký: ${e.message}');
    } catch (e) {
      return const Left('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'wrong-password') {
        return const Left('Tài khoản hoặc mật khẩu không chính xác.');
      } else if (e.code == 'user-disabled') {
        return const Left('Tài khoản này đã bị vô hiệu hóa.');
      } else if (e.code == 'too-many-requests') {
        return const Left('Bạn đã thử đăng nhập sai quá nhiều lần. Vui lòng thử lại sau.');
      } else if (e.code == 'invalid-email') {
        return const Left('Email không hợp lệ.');
      } else if (e.code == 'network-request-failed') {
        return const Left('Không có kết nối mạng. Vui lòng kiểm tra lại.');
      }
      return Left('Lỗi đăng nhập: ${e.message}');
    } catch (e) {
      return const Left('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
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
      await GoogleSignIn.instance.signOut();
      await GoogleSignIn.instance.initialize(
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
      );

      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser!.authentication;

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

  @override
  Future<Either> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Left('Người dùng chưa đăng nhập.');
      }

      bool isGoogleSignIn = false;
      bool isEmailSignIn = false;
      for (final userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          isGoogleSignIn = true;
        } else if (userInfo.providerId == 'password') {
          isEmailSignIn = true;
        }
      }

      if (isGoogleSignIn && !isEmailSignIn) {
        return const Left('Tài khoản được đăng nhập bằng Google, không thể đổi mật khẩu tại đây.');
      }

      // 1. Re-authenticate
      if (user.email == null) {
        return const Left('Tài khoản không có email để xác thực.');
      }
      
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // 2. Cập nhật mật khẩu
      await user.updatePassword(newPassword);

      return const Right('Đổi mật khẩu thành công');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return const Left('Mật khẩu hiện tại không đúng.');
      } else if (e.code == 'weak-password') {
        return const Left('Mật khẩu mới quá yếu.');
      } else if (e.code == 'requires-recent-login') {
        return const Left('Phiên đăng nhập đã hết hạn. Vui lòng đăng xuất và đăng nhập lại.');
      }
      return Left(e.message ?? 'Lỗi Firebase: ${e.code}');
    } catch (e) {
      return Left('Đã xảy ra lỗi: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
