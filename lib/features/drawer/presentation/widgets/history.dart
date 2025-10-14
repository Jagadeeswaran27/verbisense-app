import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/features/drawer/presentation/widgets/history_list.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
          HistoryList(),
        ],
      ),
    );
  }
}
