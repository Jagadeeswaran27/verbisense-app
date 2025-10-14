import 'package:fpdart/fpdart.dart';

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
  Future<Either<Failure, void>> signOut();
  Stream<Either<Failure, User>> userAuthStateChanges();
  Future<Either<Failure, bool>> updateFcmToken(String token);
}
