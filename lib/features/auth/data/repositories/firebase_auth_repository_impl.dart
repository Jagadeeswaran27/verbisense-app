import 'package:fpdart/fpdart.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verbisense/core/common/entities/user.dart';
import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/auth/data/datasources/firebase_remote_data_source.dart';
import 'package:verbisense/features/auth/data/models/user_model.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';

class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {
  final FirebaseRemoteDataSource remoteDataSource;
  FirebaseAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.createUserWithEmailAndPassword(
        name,
        email,
        password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Stream<Either<Failure, User>> userAuthStateChanges() async* {
    try {
      await for (final firebaseUser
          in remoteDataSource.userAuthStateChanges()) {
        if (firebaseUser == null) {
          yield Left(Failure('User is not authenticated'));
        } else {
          try {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser.uid)
                .get();

            if (userDoc.exists) {
              final user = UserModel.fromJson(userDoc.data()!);
              yield Right(user);
            } else {
              yield Left(Failure('User document not found.'));
            }
          } catch (e) {
            yield Left(Failure('Failed to fetch user document: $e'));
          }
        }
      }
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateFcmToken(String token) async {
    try {
      final result = await remoteDataSource.updateFcmToken(token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
