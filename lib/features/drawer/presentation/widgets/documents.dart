import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/features/drawer/presentation/widgets/documents_list.dart';

class Documents extends StatelessWidget {
  const Documents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
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

          const DocumentsList(),
        ],
      ),
    );
  }
}
