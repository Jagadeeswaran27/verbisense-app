import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/chat_history/data/models/history_model.dart';
import 'package:verbisense/features/chat_history/domain/repository/firebase_chat_history_repository.dart';

class GetChatHistory implements Usecase<List<HistoryModel>, NoParams> {
  final FirebaseChatHistoryRepository repository;

  GetChatHistory(this.repository);

  @override
  Future<Either<Failure, List<HistoryModel>>> call(NoParams params) {
    return repository.getChatHistory();
  }
}
