import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:verbisense/core/providers/providers.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/helper.dart';

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerNotifierProvider);

    if (drawerState is LoadingDrawerState) {
      return Column(
        children: [
          const SizedBox(height: 15),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      );
    } else if (drawerState is ErrorDrawerState) {
      return Text(
        'Error: ${drawerState.message}',
        style: TextStyle(color: ThemeColors.errorColor),
      );
    } else if (drawerState is LoadedDrawerState) {
      return Column(
        children: drawerState.history.map(
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
                Navigator.pop(context),
                // widget.getChatData(historyItem.date),
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
