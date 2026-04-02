import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';

abstract class FirebaseFileRepository {
  Future<Either<Failure, List<String>>> getUploadedFiles();
  Future<Either<Failure, String>> uploadFile(File file);
  Future<Either<Failure, void>> deleteFile(String fileName);
}
