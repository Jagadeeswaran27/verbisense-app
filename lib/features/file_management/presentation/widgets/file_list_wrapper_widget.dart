import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/features/file_management/presentation/widgets/file_list_widget.dart';

class FileListWrapperWidget extends StatelessWidget {
  const FileListWrapperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.document_scanner),
          title: const Text(DrawerStrings.documents),
          onTap: () {},
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          DrawerStrings.uploadedDocumentsMax3Mb,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        const FileListWidget(),
      ],
    );
  }
}
