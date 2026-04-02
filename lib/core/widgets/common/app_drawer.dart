import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verbisense/core/widgets/common/custom_drawer_header.dart';

import 'package:verbisense/features/chat_history/presentation/widgets/chat_history_widget.dart';
import 'package:verbisense/features/file_management/presentation/widgets/file_list_wrapper_widget.dart';
import 'package:verbisense/features/file_management/presentation/widgets/file_upload_widget.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});

  @override
  ConsumerState createState() => AppDrawerState();
}

class AppDrawerState extends ConsumerState<AppDrawer> {
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
          const CustomDrawerHeader(),
          const FileUploadWidget(),
          const Divider(),
          const FileListWrapperWidget(),
          const Spacer(),
          const ChatHistoryWidget(),
        ],
      ),
    );
  }
}
