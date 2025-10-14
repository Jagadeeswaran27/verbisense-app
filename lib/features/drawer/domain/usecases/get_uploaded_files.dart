import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/drawer/domain/repository/firebase_drawer_repository.dart';

class GetUploadedFiles implements Usecase<List<String>, NoParams> {
  final FirebaseDrawerRepository firebaseDrawerRepository;

  GetUploadedFiles(this.firebaseDrawerRepository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return firebaseDrawerRepository.getUploadedFiles();
  }
}
