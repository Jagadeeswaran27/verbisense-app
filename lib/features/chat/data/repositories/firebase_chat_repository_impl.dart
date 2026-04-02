import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/chat/data/datasources/api_chat_remote_datasource.dart';
import 'package:verbisense/features/chat/data/datasources/firebase_chat_remote_datasource.dart';
import 'package:verbisense/features/chat/data/models/chat_model.dart';
import 'package:verbisense/features/chat/domain/repository/firebase_chat_repository.dart';

class FirebaseChatRepositoryImpl implements FirebaseChatRepository {
  final FirebaseChatRemoteDataSource remoteDataSource;
  final ApiChatRemoteDatasource apiChatRemoteDatasource;

  FirebaseChatRepositoryImpl(
    this.remoteDataSource,
    this.apiChatRemoteDatasource,
  );

  @override
  Future<Either<Failure, List<ChatModel>>> getChatData(String date) async {
    try {
      final chatData = await remoteDataSource.getChatData(date);
      return Right(chatData);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(
    String query,
    List<String> files,
    String? date,
  ) async {
    try {
      await apiChatRemoteDatasource.sendMessage(query, files, date);
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
