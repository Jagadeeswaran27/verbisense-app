import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/common/entities/user.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';

class CreateUser implements Usecase<User, UserSignupParms> {
  final FirebaseAuthRepository repository;
  const CreateUser(this.repository);
  @override
  Future<Either<Failure, User>> call(UserSignupParms params) async {
    return await repository.createUserWithEmailAndPassword(
      params.name,
      params.email,
      params.password,
    );
  }
}

class UserSignupParms {
  final String name;
  final String email;
  final String password;

  UserSignupParms({
    required this.name,
    required this.email,
    required this.password,
  });
}
