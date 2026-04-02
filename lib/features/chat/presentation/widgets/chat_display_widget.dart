import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/providers/active_chat_provider.dart';
import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/widgets/loader/progressive_dots/progressive_dots.dart';
import 'package:verbisense/features/chat/presentation/providers/chat_data_provider.dart';
import 'package:verbisense/features/chat/presentation/widgets/welcome_message.dart';

class ChatDataDisplayWidget extends ConsumerStatefulWidget {
  const ChatDataDisplayWidget({super.key});

  @override
  ConsumerState<ChatDataDisplayWidget> createState() =>
      _ChatDataDisplayWidgetState();
}

class _ChatDataDisplayWidgetState extends ConsumerState<ChatDataDisplayWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(ChatDataDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && mounted) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatDataState = ref.watch(chatDataNotifierProvider);

    ref.listen<ActiveChatState>(
      activeChatProviderNotifier,
      (previous, next) {
        if (next is ActiveChatStateLoaded) {
          ref.read(chatDataNotifierProvider.notifier).fetchChatData(next.date);
        }
      },
    );

    if (chatDataState is ChatDataLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (chatDataState is ChatDataLoaded) {
      if (chatDataState.chatData.isEmpty) return const WelcomeMessage();
      return GestureDetector(
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: chatDataState.chatData.length,
          itemBuilder: (context, index) {
            final message = chatDataState.chatData[index];
            return Column(
              children: [
                // Display the user's message
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: ThemeColors.black,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "User 1",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: ThemeColors.white,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.account_circle_outlined,
                              size: 25,
                              color: ThemeColors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SelectableText(
                          message.query,
                          textAlign: TextAlign.left, // Aligns text to the right
                          style: TextStyle(
                            fontSize: 15,
                            color: ThemeColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Display the assistant's response
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: ThemeColors.chatInput,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeColors.primary,
                              ),
                              child: Center(
                                child: Text(
                                  'VS',
                                  style: TextStyle(
                                    color: ThemeColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CommonStrings.verbisense,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                        if (message.summary.isEmpty &&
                            message.heading1 == null &&
                            message.heading2.isEmpty &&
                            message.keyTakeaways.isEmpty &&
                            message.example.isEmpty &&
                            message.error.isEmpty)
                          Center(
                            child: ProgressiveDots(
                              color: ThemeColors.black,
                              size: 50,
                            ),
                          ),
                        if (message.summary.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(message.summary),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        if (message.heading1 != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SelectableText(
                              message.heading1!,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (message.heading2.isNotEmpty)
                          ...message.heading2.map((heading) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    heading,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  if (message.points.points[heading] != null)
                                    ...message.points.points[heading]!.map(
                                      (point) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('• '),
                                            Expanded(
                                              child: SelectableText(
                                                point,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  height: 1.7,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        if (message.keyTakeaways.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  'Key Takeaways:',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 10),
                                SelectableText(message.keyTakeaways),
                              ],
                            ),
                          ),
                        if (message.example.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  'Examples:',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 10),
                                ...message.example.map((example) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('• '),
                                        Expanded(
                                          child: SelectableText(example),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        if (message.error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SelectableText(
                              'Error: ${message.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
    // Handle error state
    return const SizedBox();
  }
}
