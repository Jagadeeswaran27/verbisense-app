import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/domain/repository/firebase_auth_core_repository.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';

class Signout implements Usecase<void, NoParams> {
  final FirebaseAuthCoreRepository repository;
  Signout(this.repository);
  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
