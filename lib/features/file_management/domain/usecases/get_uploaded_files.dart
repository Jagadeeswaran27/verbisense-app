import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/file_management/domain/repository/firebase_file_repository.dart';

class GetUploadedFiles implements Usecase<List<String>, NoParams> {
  final FirebaseFileRepository repository;

  GetUploadedFiles(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getUploadedFiles();
  }
}
