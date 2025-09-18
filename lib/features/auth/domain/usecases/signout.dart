import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';

class Signout implements Usecase<void, NoParams> {
  final FirebaseAuthRepository repository;
  Signout(this.repository);
  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
