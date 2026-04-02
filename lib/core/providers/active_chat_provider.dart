import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/utils/helper.dart';

sealed class ActiveChatState {
  const ActiveChatState();

  const factory ActiveChatState.initial(String date) = ActiveChatStateInitial;
  const factory ActiveChatState.loaded(String date) = ActiveChatStateLoaded;
}

class ActiveChatStateInitial extends ActiveChatState {
  final String date;
  const ActiveChatStateInitial(this.date);
}

class ActiveChatStateLoaded extends ActiveChatState {
  final String date;
  const ActiveChatStateLoaded(this.date);
}

class ActiveChatNotifier extends StateNotifier<ActiveChatState> {
  ActiveChatNotifier() : super(ActiveChatState.initial(formatDateAsString()));

  void setActiveChat(String date) {
    state = ActiveChatStateLoaded(date);
  }
}

final activeChatProviderNotifier =
    StateNotifierProvider<ActiveChatNotifier, ActiveChatState>((ref) {
      return ActiveChatNotifier();
    });
