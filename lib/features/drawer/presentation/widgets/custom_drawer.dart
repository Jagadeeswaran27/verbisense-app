import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/features/drawer/presentation/widgets/documents.dart';
import 'package:verbisense/features/drawer/presentation/widgets/history.dart';
import 'package:verbisense/features/drawer/presentation/widgets/upload_file.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({
    super.key,
    required this.deleteFile,
    required this.getChatData,
    required this.activeDate,
  });

  final Future<bool> Function(String url, String fileName) deleteFile;
  final void Function(String date) getChatData;
  final String activeDate;

  @override
  ConsumerState createState() => CustomDrawerState();
}

class CustomDrawerState extends ConsumerState<CustomDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 40,
        left: 16,
        right: 16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                CommonStrings.verbisense,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          UploadFile(),
          const Divider(),
          const Documents(),
          const Spacer(),
          const History(),
        ],
      ),
    );
  }
}
