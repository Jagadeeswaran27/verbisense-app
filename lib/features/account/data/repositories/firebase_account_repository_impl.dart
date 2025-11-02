import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/account/data/datasources/firebase_account_remote_datasource.dart';
import 'package:verbisense/features/account/domain/repository/firebase_account_repository.dart';

class FirebaseAccountRepositoryImpl implements FirebaseAccountRepository {
  final FirebaseAccountRemoteDatasource remoteDataSource;
  FirebaseAccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<String>>> getUserProviderInfo() async {
    try {
      final providers = await remoteDataSource.getUserProviderInfo();
      return Right(providers);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserName(String name) async {
    try {
      final result = await remoteDataSource.updateUserName(name);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final result = await remoteDataSource.changePassword(
        currentPassword,
        newPassword,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
