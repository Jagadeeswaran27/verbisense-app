import 'package:fpdart/fpdart.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/error/failures.dart';

abstract class FirebaseAuthRepository {
  Future<Either<Failure, User>> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  );

  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
  Stream<firebase_auth.User?> userAuthStateChanges();
  Future<Either<Failure, bool>> updateFcmToken(String token);
}
