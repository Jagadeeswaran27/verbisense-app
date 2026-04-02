import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/file_management/domain/repository/firebase_file_repository.dart';

class DeleteFile implements Usecase<void, String> {
  final FirebaseFileRepository repository;

  DeleteFile(this.repository);

  @override
  Future<Either<Failure, void>> call(String fileName) async {
    return await repository.deleteFile(fileName);
  }
}
