import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/drawer/data/models/history_model.dart';
import 'package:verbisense/features/drawer/domain/repository/firebase_drawer_repository.dart';

class GetChatHistory implements Usecase<List<HistoryModel>, NoParams> {
  final FirebaseDrawerRepository repository;

  GetChatHistory(this.repository);

  @override
  Future<Either<Failure, List<HistoryModel>>> call(NoParams params) {
    return repository.getChatHistory();
  }
}
