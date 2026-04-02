import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/chat_history/data/models/history_model.dart';
import 'package:verbisense/features/chat_history/domain/usecases/get_chat_history.dart';
import 'package:verbisense/init_dependencies.dart';

sealed class ChatHistoryState {
  const ChatHistoryState();

  factory ChatHistoryState.initial() = InitialChatHistoryState;
  factory ChatHistoryState.loading() = LoadingChatHistoryState;
  factory ChatHistoryState.loaded(List<HistoryModel> history) =
      LoadedChatHistoryState;
  factory ChatHistoryState.error(String message) = ErrorChatHistoryState;
}

class InitialChatHistoryState extends ChatHistoryState {
  const InitialChatHistoryState();
}

class LoadingChatHistoryState extends ChatHistoryState {
  const LoadingChatHistoryState();
}

class LoadedChatHistoryState extends ChatHistoryState {
  final List<HistoryModel> history;
  const LoadedChatHistoryState(this.history);
}

class ErrorChatHistoryState extends ChatHistoryState {
  final String message;
  const ErrorChatHistoryState(this.message);
}

class ChatHistoryNotifier extends StateNotifier<ChatHistoryState> {
  final GetChatHistory _chatHistory;
  ChatHistoryNotifier(this._chatHistory)
    : super(const InitialChatHistoryState()) {
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    state = const LoadingChatHistoryState();
    final result = await _chatHistory.call(NoParams());
    result.fold(
      (failure) {
        state = ErrorChatHistoryState(failure.message);
      },
      (history) {
        state = LoadedChatHistoryState(history);
      },
    );
  }
}

final chatHistoryNotifierProvider =
    StateNotifierProvider<ChatHistoryNotifier, ChatHistoryState>((ref) {
      return ChatHistoryNotifier(
        serviceLocator<GetChatHistory>(),
      );
    });
