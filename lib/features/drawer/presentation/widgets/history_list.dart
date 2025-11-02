import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/providers/drawer_provider.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/helper.dart';
import 'package:verbisense/core/widgets/loader/custom_shimmer.dart';

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerNotifierProvider);

    if (drawerState is LoadingDrawerState) {
      return CustomShimmer(
        verticalSpacing: 20,
        height: 25,
        itemCount: 4,
      );
    } else if (drawerState is ErrorDrawerState) {
      return Text(
        'Error: ${drawerState.message}',
        style: TextStyle(color: ThemeColors.errorColor),
      );
    } else if (drawerState is LoadedDrawerState) {
      AppLogger.i('Loaded history items: ${drawerState.history.length}');
      if (drawerState.history.isEmpty) {
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
