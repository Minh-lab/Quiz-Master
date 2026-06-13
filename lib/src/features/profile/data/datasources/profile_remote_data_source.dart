import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile({required String uid, String? displayName, File? avatarFile});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    File? avatarFile,
  }) async {
    String? downloadUrl;

    // 1. Upload Firebase Storage
    if (avatarFile != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storageRef = storage.ref().child('users/$uid/avatar/avatar_$timestamp.jpg');
      
      final uploadTask = await storageRef.putFile(avatarFile);
      downloadUrl = await uploadTask.ref.getDownloadURL();
    }

    // 2. Update Firestore
    Map<String, dynamic> updateData = {};
    if (displayName != null && displayName.isNotEmpty) {
      updateData['displayName'] = displayName.trim();
    }
    if (downloadUrl != null) {
      updateData['photoUrl'] = downloadUrl;
    }

    if (updateData.isNotEmpty) {
      await firestore.collection('users').doc(uid).set(
        updateData, 
        SetOptions(merge: true), // Quan trọng: Tránh ghi đè xóa mất dữ liệu cũ
      );
    }

    // 3. Update FirebaseAuth currentUser (để đồng bộ)
    final user = auth.currentUser;
    if (user != null && user.uid == uid) {
      if (displayName != null) await user.updateDisplayName(displayName.trim());
      if (downloadUrl != null) await user.updatePhotoURL(downloadUrl);
    }
  }
}
