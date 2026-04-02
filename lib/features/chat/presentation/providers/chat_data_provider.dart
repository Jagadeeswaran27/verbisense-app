import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/utils/helper.dart';
import 'package:verbisense/features/chat/data/models/chat_model.dart';
import 'package:verbisense/features/chat/domain/usecases/get_chat_data.dart';
import 'package:verbisense/features/chat/domain/usecases/send_message.dart';
import 'package:verbisense/init_dependencies.dart';

sealed class ChatDataState {
  const ChatDataState();

  factory ChatDataState.initial() = ChatDataInitial;
  factory ChatDataState.loading() = ChatDataLoading;
  factory ChatDataState.loaded(List<ChatModel> chatData) = ChatDataLoaded;
  factory ChatDataState.error(String message) = ChatDataError;
}

class ChatDataInitial extends ChatDataState {
  const ChatDataInitial();
}

class ChatDataLoading extends ChatDataState {
  const ChatDataLoading();
}

class ChatDataLoaded extends ChatDataState {
  final List<ChatModel> chatData;

  const ChatDataLoaded(this.chatData);
}

class ChatDataError extends ChatDataState {
  final String message;

  const ChatDataError(this.message);
}

class ChatDataNotifier extends StateNotifier<ChatDataState> {
  final GetChatData getChatDataUsecase;
  final SendMessage sendMessageUsecase;

  ChatDataNotifier(this.getChatDataUsecase, this.sendMessageUsecase)
    : super(ChatDataState.initial()) {
    String todayDate = formatDateAsString();
    fetchChatData(todayDate);
  }

  Future<void> fetchChatData(String date) async {
    state = ChatDataState.loading();

    final result = await getChatDataUsecase(date);

    result.fold(
      (failure) {
        state = ChatDataState.error(failure.message);
      },
      (chatData) {
        state = ChatDataState.loaded(chatData);
      },
    );
  }

  Future<void> sendMessage(String query, List<String> files) async {
    state = ChatDataState.loading();

    final result = await sendMessageUsecase(
      SendMessageParams(query: query, files: files),
    );

    result.fold(
      (failure) {
        state = ChatDataState.error(failure.message);
      },
      (chatData) {
        // TODO: Add chat data to existing list
        // state = ChatDataState.loaded(chatData);
      },
    );
  }
}

final chatDataNotifierProvider =
    StateNotifierProvider<ChatDataNotifier, ChatDataState>((ref) {
      return ChatDataNotifier(
        serviceLocator(),
        serviceLocator(),
      );
    });
