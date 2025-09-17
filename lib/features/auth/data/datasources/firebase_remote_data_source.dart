import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verbisense/core/config/app_logger.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/features/auth/data/models/user_model.dart';

abstract class FirebaseRemoteDataSource {
  Future<UserModel> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  );
  // Future<void> signOut();
}

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseRemoteDataSourceImpl(this.firebaseAuth);
  @override
  Future<UserModel> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const ServerException('User data is null');
      }
      final userData = {
        "uid": user.uid,
        "email": email,
        "name": name,
      };
      _firestore.collection("users").doc(user.uid).set(userData);
      return UserModel.fromJson(userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw const ServerException('Email already in use');
        case 'invalid-email':
          throw const ServerException('Invalid email');
        case 'operation-not-allowed':
          throw const ServerException('Operation not allowed');
        case 'weak-password':
          throw const ServerException('Weak password');
        default:
          throw ServerException(e.message ?? 'Authentication error');
      }
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const ServerException('User data is null');
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw const ServerException('User data not found');
      }
      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e.code);
      switch (e.code) {
        case 'invalid-credential':
          throw const ServerException('Invalid credential');
        case 'user-disabled':
          throw const ServerException('User disabled');
        case 'user-not-found':
          throw const ServerException('User not found');
        case 'wrong-password':
          throw const ServerException('Wrong password');
        default:
          throw ServerException(e.message ?? 'Authentication error');
      }
    }
  }
}
