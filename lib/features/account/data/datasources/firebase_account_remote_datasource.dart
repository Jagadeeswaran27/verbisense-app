import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/firebase_error_code.dart';
import 'package:verbisense/core/resources/strings/firebase_error_strings.dart';

abstract class FirebaseAccountRemoteDatasource {
  Future<List<String>> getUserProviderInfo();
  Future<void> updateUserName(String name);
  Future<void> changePassword(String currentPassword, String newPassword);
}

class FirebaseAccountRemoteDatasourceImpl
    implements FirebaseAccountRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAccountRemoteDatasourceImpl(
    this._firebaseAuth,
    this._firestore,
  );

  static String getFirebaseError(FirebaseException e) {
    final errorCode = FirebaseErrorCodeX.fromCode(e.code);
    if (errorCode != null) {
      return errorCode.message;
    } else {
      return e.message ?? FirebaseErrorStrings.unknownFirebaseError;
    }
  }

  @override
  Future<List<String>> getUserProviderInfo() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final providerData = user.providerData;
      return providerData.map((provider) => provider.providerId).toList();
    } on FirebaseAuthException catch (e) {
      final errorMessage = getFirebaseError(e);
      throw ServerException(errorMessage);
    } catch (e) {
      throw ServerException('Failed to get user provider info');
    }
  }

  @override
  Future<void> updateUserName(String name) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await _firestore.collection('users').doc(user.uid).update({'name': name});
    } on FirebaseAuthException catch (e) {
      final errorMessage = getFirebaseError(e);
      throw ServerException(errorMessage);
    } catch (e) {
      throw ServerException('Failed to update user name');
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      final errorMessage = getFirebaseError(e);
      throw ServerException(errorMessage);
    } catch (e) {
      throw ServerException('Failed to change password');
    }
  }
}
