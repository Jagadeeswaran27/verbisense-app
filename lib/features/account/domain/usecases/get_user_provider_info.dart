import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/account/domain/repository/firebase_account_repository.dart';

class GetUserProviderInfo implements Usecase<List<String>, NoParams> {
  final FirebaseAccountRepository repository;
  GetUserProviderInfo(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getUserProviderInfo();
  }
}
