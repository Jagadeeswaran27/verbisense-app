import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/firebase_error_code.dart';
import 'package:verbisense/core/models/core_user_model.dart';
import 'package:verbisense/core/resources/strings/firebase_error_strings.dart';

abstract class FirebaseAuthCoreRemoteDatasource {
  Future<CoreUserModel> getCurrentUser();
  Stream<User?> userAuthStateChanges();
  Future<void> signOut();
  Future<bool> updateFcmToken(String token);
}

class FirebaseAuthCoreRemoteDatasourceImpl
    implements FirebaseAuthCoreRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseAuthCoreRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  static String getFirebaseError(FirebaseException e) {
    final errorCode = FirebaseErrorCodeX.fromCode(e.code);
    if (errorCode != null) {
      return errorCode.message;
    } else {
      return e.message ?? FirebaseErrorStrings.unknownFirebaseError;
    }
  }

  @override
  Future<CoreUserModel> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException(FirebaseErrorStrings.userDataIsNull);
      }
      AppLogger.i('Current User UID: ${user.uid}');
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw const ServerException(FirebaseErrorStrings.userDataNotFound);
      }
      AppLogger.i('User Document Data: ${userDoc.data().toString()}');
      return CoreUserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.code);
      throw ServerException(getFirebaseError(e));
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<User?> userAuthStateChanges() {
    return firebaseAuth.authStateChanges().map((user) => user);
  }

  @override
  Future<void> signOut() {
    try {
      return firebaseAuth.signOut();
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> updateFcmToken(String token) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException(FirebaseErrorStrings.userDataIsNull);
      }
      final userDoc = firestore.collection('users').doc(user.uid);
      await userDoc.update({
        'fcmToken': token,
      });
      return true;
    } catch (e) {
      AppLogger.e(e.toString());
      throw ServerException(e.toString());
    }
  }
}
