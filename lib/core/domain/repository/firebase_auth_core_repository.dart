import 'package:fpdart/fpdart.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/error/failures.dart';

abstract class FirebaseAuthCoreRepository {
  Future<Either<Failure, User>> getCurrentUser();
  Stream<firebase_auth.User?> userAuthStateChanges();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, bool>> updateFcmToken(String token);
}
