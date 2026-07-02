import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.isAnonymous,
    required super.isEmailVerified,
    required super.provider,
    required super.email,
    required super.displayName,
    required super.createdAt,
    required super.photoUrl,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'isAnonymous': isAnonymous,
    'isEmailVerified': isEmailVerified,
    'provider': provider.name,
    'createdAt': createdAt,
  };

  UserEntity toEntity() => this;

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    // Xác định phương thức đăng nhập từ danh sách providerData
    AppAuthProvider provider = AppAuthProvider.anonymous;
    if (!firebaseUser.isAnonymous && firebaseUser.providerData.isNotEmpty) {
      final providerId = firebaseUser.providerData.first.providerId;
      if (providerId == 'google.com') {
        provider = AppAuthProvider.google;
      } else if (providerId == 'facebook.com') {
        provider = AppAuthProvider.facebook;
      } else if (providerId == 'password') {
        provider = AppAuthProvider.email;
      }
    }

    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      isAnonymous: firebaseUser.isAnonymous,
      isEmailVerified: firebaseUser.emailVerified,
      provider: provider,
      createdAt: firebaseUser.metadata.creationTime,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      isAnonymous: json['isAnonymous'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      provider: AppAuthProvider.values.firstWhere(
        (e) => e.name == json['provider'] || e.toString() == json['provider'],
        orElse: () => AppAuthProvider.email,
      ),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
