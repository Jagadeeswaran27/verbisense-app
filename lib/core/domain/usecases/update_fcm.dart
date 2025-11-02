import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/domain/repository/firebase_auth_core_repository.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';

class UpdateFcm implements Usecase<bool, String> {
  final FirebaseAuthCoreRepository repository;

  UpdateFcm(this.repository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.updateFcmToken(params);
  }
}
