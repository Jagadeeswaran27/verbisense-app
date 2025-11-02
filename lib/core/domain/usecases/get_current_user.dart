import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/domain/repository/firebase_auth_core_repository.dart';
import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';

class GetCurrentUser implements Usecase<User, NoParams> {
  final FirebaseAuthCoreRepository firebaseAuthCoreRepository;

  GetCurrentUser(this.firebaseAuthCoreRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await firebaseAuthCoreRepository.getCurrentUser();
  }
}
