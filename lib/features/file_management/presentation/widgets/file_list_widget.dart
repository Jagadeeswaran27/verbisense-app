import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/themes/fonts.dart';
import 'package:verbisense/core/utils/helper.dart';
import 'package:verbisense/core/widgets/common/custom_shimmer.dart';
import 'package:verbisense/features/file_management/presentation/providers/file_management_provider.dart';

class FileListWidget extends ConsumerWidget {
  const FileListWidget({super.key});

  Future<void> _openFile(String url) async {
    AppLogger.i(url);
    try {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
      throw 'Error opening file: $e';
    }
  }

  Future<void> _handleDeleteFile(WidgetRef ref, String fileUrl) async {
    AppLogger.i('Deleting file: $fileUrl');
    final String fileName = getFilenameFromUrl(fileUrl);
    await ref
        .read(fileManagementNotifierProvider.notifier)
        .deleteFile(fileName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(fileManagementNotifierProvider);
    final Size screenSize = MediaQuery.of(context).size;

    if (drawerState is LoadingFileManagementState) {
      return CustomShimmer(
        verticalSpacing: 10,
        height: 22,
        itemCount: 3,
      );
    } else if (drawerState is ErrorFileManagementState) {
      return Text(
        'Error: ${drawerState.message}',
        style: TextStyle(color: ThemeColors.errorColor),
      );
    } else if (drawerState is LoadedFileManagementState) {
      if (drawerState.files.isEmpty) {
        return Text(DrawerStrings.noFilesUploaded);
      }
      final isDeleting = drawerState.deletingFileName != null;
      final deletingFileName = drawerState.deletingFileName;
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
                    style: deletingFileName == getFilenameFromUrl(fileItem)
                        ? Theme.of(
                            context,
                          ).textTheme.bodySmallBlack.withOpacity(0.5)
                        : Theme.of(context).textTheme.bodySmallBlack,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _openFile(fileItem),
                  child: const Icon(
                    Icons.remove_red_eye_outlined,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: isDeleting
                      ? null
                      : () => _handleDeleteFile(ref, fileItem),
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
