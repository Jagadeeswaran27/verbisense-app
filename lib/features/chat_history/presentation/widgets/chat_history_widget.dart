import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/features/chat_history/presentation/widgets/chat_history_list_widget.dart';

class ChatHistoryWidget extends StatelessWidget {
  const ChatHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DrawerStrings.history,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).pop(),
                // widget.getChatData(formatDateAsString()),
              },
              child: Text(
                DrawerStrings.today,
                style: TextStyle(
                  fontWeight:
                      // widget.activeDate == formatDateAsString()
                      // ? FontWeight.w700
                      FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const ChatHistoryListWidget(),
      ],
    );
  }
}
