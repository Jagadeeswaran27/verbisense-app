import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';

class UpdateFcm implements Usecase<bool, String> {
  final FirebaseAuthRepository repository;

  UpdateFcm(this.repository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.updateFcmToken(params);
  }
}
