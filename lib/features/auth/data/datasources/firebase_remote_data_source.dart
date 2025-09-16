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
  // Future<void> signInWithEmailAndPassword(
  //   String email,
  //   String password,
  // );
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
      AppLogger.i('User created: ${user.uid}');
      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<void> signInWithEmailAndPassword(
  //   String email,
  //   String password,
  // ) {
  //   // TODO: implement signInWithEmailAndPassword
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> signOut() {
  //   // TODO: implement signOut
  //   throw UnimplementedError();
  // }
}
