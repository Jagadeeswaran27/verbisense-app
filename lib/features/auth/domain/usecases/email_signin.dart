import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';

class EmailSignin implements Usecase<User, EmailSigninParams> {
  final FirebaseAuthRepository repository;
  const EmailSignin(this.repository);
  @override
  Future<Either<Failure, User>> call(EmailSigninParams params) async {
    return await repository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class EmailSigninParams {
  final String email;
  final String password;

  EmailSigninParams({
    required this.email,
    required this.password,
  });
}
