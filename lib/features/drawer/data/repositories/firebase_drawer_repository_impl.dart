import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/drawer/data/datasources/firebase_drawer_remote_data_source.dart';
import 'package:verbisense/features/drawer/data/models/history_model.dart';
import 'package:verbisense/features/drawer/domain/repository/firebase_drawer_repository.dart';

class FirebaseDrawerRepositoryImpl implements FirebaseDrawerRepository {
  final FirebaseDrawerRemoteDataSource firebaseRemoteDataSourceImpl;
  FirebaseDrawerRepositoryImpl(this.firebaseRemoteDataSourceImpl);

  @override
  Future<Either<Failure, List<String>>> getUploadedFiles() async {
    try {
      final files = await firebaseRemoteDataSourceImpl.getUploadedFiles();
      return Right(files);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<HistoryModel>>> getChatHistory() async {
    try {
      final histories = await firebaseRemoteDataSourceImpl.getChatHistory();
      return Right(histories);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile(File file) async {
    try {
      final fileUrl = await firebaseRemoteDataSourceImpl.uploadFile(file);
      return Right(fileUrl);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
