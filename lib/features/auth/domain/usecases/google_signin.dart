import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/common/entities/user.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';

class GoogleSignin implements Usecase<User, NoParams> {
  final FirebaseAuthRepository repository;
  const GoogleSignin(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
