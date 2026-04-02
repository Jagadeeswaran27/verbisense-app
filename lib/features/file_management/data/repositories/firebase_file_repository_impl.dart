import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/file_management/data/datasources/firebase_file_remote_datasource.dart';
import 'package:verbisense/features/file_management/domain/repository/firebase_file_repository.dart';

class FirebaseFileRepositoryImpl implements FirebaseFileRepository {
  final FirebaseFileRemoteDatasource remoteDatasource;

  FirebaseFileRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<String>>> getUploadedFiles() async {
    try {
      final files = await remoteDatasource.getUploadedFiles();
      return Right(files);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile(File file) async {
    try {
      final fileUrl = await remoteDatasource.uploadFile(file);
      return Right(fileUrl);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFile(String fileName) async {
    try {
      await remoteDatasource.deleteFile(fileName);
      return Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
