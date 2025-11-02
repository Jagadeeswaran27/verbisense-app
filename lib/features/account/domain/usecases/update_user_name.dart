import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/account/domain/repository/firebase_account_repository.dart';

class UpdateUserName implements Usecase<void, String> {
  final FirebaseAccountRepository repository;

  UpdateUserName(this.repository);

  @override
  Future<Either<Failure, void>> call(String name) {
    return repository.updateUserName(name);
  }
}
