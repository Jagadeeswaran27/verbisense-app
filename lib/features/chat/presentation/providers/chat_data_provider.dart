import 'package:flutter_riverpod/legacy.dart';
import 'package:verbisense/core/utils/helper.dart';

import 'package:verbisense/features/chat/domain/usecases/get_chat_data.dart';
import 'package:verbisense/features/drawer/data/models/chat_model.dart';

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

  ChatDataNotifier(this.getChatDataUsecase) : super(ChatDataState.initial()) {
    String todayDate = formatDateAsString();
    fetchChatData(todayDate);
  }

  Future<void> fetchChatData(String? date) async {
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
}
