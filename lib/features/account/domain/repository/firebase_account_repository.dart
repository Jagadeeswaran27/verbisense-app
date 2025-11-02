import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';

abstract class FirebaseAccountRepository {
  Future<Either<Failure, List<String>>> getUserProviderInfo();
  Future<Either<Failure, void>> updateUserName(String name);
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  );
}
