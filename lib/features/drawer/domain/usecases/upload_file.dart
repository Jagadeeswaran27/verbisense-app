import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/drawer/domain/repository/firebase_drawer_repository.dart';

class UploadFile implements Usecase<String, File> {
  final FirebaseDrawerRepository repository;

  UploadFile(this.repository);

  @override
  Future<Either<Failure, String>> call(File file) {
    return repository.uploadFile(file);
  }
}
