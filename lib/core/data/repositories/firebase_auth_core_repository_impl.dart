import 'package:fpdart/fpdart.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:verbisense/core/data/datasources/firebase_auth_core_remote_datasource.dart';
import 'package:verbisense/core/domain/repository/firebase_auth_core_repository.dart';
import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/failures.dart';

class FirebaseAuthCoreRepositoryImpl implements FirebaseAuthCoreRepository {
  final FirebaseAuthCoreRemoteDatasource firebaseAuthCoreRemoteDatasource;

  FirebaseAuthCoreRepositoryImpl(this.firebaseAuthCoreRemoteDatasource);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await firebaseAuthCoreRemoteDatasource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Stream<firebase_auth.User?> userAuthStateChanges() =>
      firebaseAuthCoreRemoteDatasource.userAuthStateChanges();

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await firebaseAuthCoreRemoteDatasource.signOut();
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateFcmToken(String token) async {
    try {
      final result = await firebaseAuthCoreRemoteDatasource.updateFcmToken(
        token,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
