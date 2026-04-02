import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/chat_history/data/datasources/firebase_chat_history_remote_datasource.dart';
import 'package:verbisense/features/chat_history/data/models/history_model.dart';
import 'package:verbisense/features/chat_history/domain/repository/firebase_chat_history_repository.dart';

class FirebaseChatHistoryRepositoryImpl
    implements FirebaseChatHistoryRepository {
  final FirebaseChatHistoryRemoteDatasource remoteDatasource;

  FirebaseChatHistoryRepositoryImpl(
    this.remoteDatasource,
  );

  @override
  Future<Either<Failure, List<HistoryModel>>> getChatHistory() async {
    try {
      List<HistoryModel> chatHistory = await remoteDatasource.getChatHistory();
      return Right(chatHistory);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
