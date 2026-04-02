import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/chat_history/data/models/history_model.dart';

abstract class FirebaseChatHistoryRepository {
  Future<Either<Failure, List<HistoryModel>>> getChatHistory();
}
