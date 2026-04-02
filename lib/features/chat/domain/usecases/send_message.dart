import 'package:fpdart/fpdart.dart';

import 'package:verbisense/core/error/failures.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/chat/domain/repository/firebase_chat_repository.dart';

class SendMessage implements Usecase<void, SendMessageParams> {
  final FirebaseChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      params.query,
      params.files,
      params.date,
    );
  }
}

class SendMessageParams {
  final String query;
  final List<String> files;
  final String? date;

  SendMessageParams({
    required this.query,
    required this.files,
    this.date,
  });
}
