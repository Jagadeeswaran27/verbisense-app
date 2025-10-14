import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:verbisense/core/providers/providers.dart';
import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/themes/fonts.dart';
import 'package:verbisense/core/utils/helper.dart';

class DocumentsList extends ConsumerWidget {
  const DocumentsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerNotifierProvider);
    final Size screenSize = MediaQuery.of(context).size;

    if (drawerState is LoadingDrawerState) {
      return Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              width: double.infinity,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
    } else if (drawerState is ErrorDrawerState) {
      return Text(
        'Error: ${drawerState.message}',
        style: TextStyle(color: ThemeColors.errorColor),
      );
    } else if (drawerState is LoadedDrawerState) {
      if (drawerState.files.isEmpty) {
        return Text(DrawerStrings.noFilesUploaded);
      }
      return Column(
        children: drawerState.files.map((fileItem) {
          return Container(
            color: ThemeColors.white,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.55,
                  child: Text(
                    getFilenameFromUrl(fileItem),
                    style: Theme.of(context).textTheme.bodySmallBlack,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  // onTap: () => openFile(fileItem),
                  child: const Icon(
                    Icons.remove_red_eye_outlined,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  // onTap: () => handleDeleteFile(
                  //   fileItem,
                  //   getFilenameFromUrl(fileItem),
                  // ),
                  child: const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else {
      return const SizedBox();
    }
  }
}
