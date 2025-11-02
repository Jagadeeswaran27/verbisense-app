import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/account/domain/repository/firebase_account_repository.dart';

class ChangePassword implements Usecase<void, ChangePasswordParams> {
  final FirebaseAccountRepository _repository;

  ChangePassword(this._repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return _repository.changePassword(
      params.currentPassword,
      params.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}
