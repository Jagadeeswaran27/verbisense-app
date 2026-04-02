import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/features/chat/data/models/chat_model.dart';

abstract class FirebaseChatRepository {
  Future<Either<Failure, List<ChatModel>>> getChatData(String date);
  Future<Either<Failure, void>> sendMessage(
    String query,
    List<String> files,
    String? date,
  );
}
