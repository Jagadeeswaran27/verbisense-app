import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/chat/domain/repository/firebase_chat_repository.dart';
import 'package:verbisense/features/drawer/data/models/chat_model.dart';

class GetChatData implements Usecase<List<ChatModel>, String?> {
  final FirebaseChatRepository repository;

  GetChatData(this.repository);

  @override
  Future<Either<Failure, List<ChatModel>>> call(String? date) {
    return repository.getChatData(date);
  }
}
