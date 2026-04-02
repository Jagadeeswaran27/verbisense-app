import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/providers/active_chat_provider.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/helper.dart';
import 'package:verbisense/core/widgets/common/custom_shimmer.dart';
import 'package:verbisense/features/chat_history/presentation/providers/chat_history_provider.dart';

class ChatHistoryListWidget extends ConsumerWidget {
  const ChatHistoryListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatHistoryState = ref.watch(chatHistoryNotifierProvider);

    if (chatHistoryState is LoadingChatHistoryState) {
      return CustomShimmer(
        verticalSpacing: 20,
        height: 25,
        itemCount: 4,
      );
    } else if (chatHistoryState is ErrorChatHistoryState) {
      return Text(
        'Error: ${chatHistoryState.message}',
        style: TextStyle(color: ThemeColors.errorColor),
      );
    } else if (chatHistoryState is LoadedChatHistoryState) {
      if (chatHistoryState.history.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Icon(
                Icons.history,
                size: 40,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No History Yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      }
      return Column(
        children: chatHistoryState.history.map(
          (historyItem) {
            return ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const Icon(Icons.calendar_today),
              title: Text(
                '${formatDate(historyItem.cid)} - ${historyItem.heading1}',
                style: TextStyle(
                  fontWeight:
                      // widget.activeDate == historyItem.date
                      // ? FontWeight.w700
                      FontWeight.w500,
                ),
              ),
              onTap: () => {
                ref
                    .read(activeChatProviderNotifier.notifier)
                    .setActiveChat(historyItem.cid),
              },
              dense: true,
            );
          },
        ).toList(),
      );
    } else {
      return const SizedBox();
    }
  }
}
