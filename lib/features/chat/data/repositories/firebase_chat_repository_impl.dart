import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/exceptions.dart';
import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/chat/data/datasources/firebase_chat_remote_datasource.dart';
import 'package:verbisense/features/chat/domain/repository/firebase_chat_repository.dart';
import 'package:verbisense/features/drawer/data/models/chat_model.dart';

class FirebaseChatRepositoryImpl implements FirebaseChatRepository {
  final FirebaseChatRemoteDataSource remoteDataSource;

  FirebaseChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatModel>>> getChatData(String? date) async {
    try {
      final chatData = await remoteDataSource.getChatData(date);
      return Right(chatData);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
