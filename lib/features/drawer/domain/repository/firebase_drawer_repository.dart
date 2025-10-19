import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/drawer/data/models/history_model.dart';

abstract class FirebaseDrawerRepository {
  Future<Either<Failure, List<String>>> getUploadedFiles();
  Future<Either<Failure, List<HistoryModel>>> getChatHistory();
  Future<Either<Failure, String>> uploadFile(File file);
  Future<Either<Failure, void>> deleteFile(String fileName);
}
