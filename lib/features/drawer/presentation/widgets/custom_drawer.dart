import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/features/drawer/presentation/widgets/custom_drawer_header.dart';
import 'package:verbisense/features/drawer/presentation/widgets/documents.dart';
import 'package:verbisense/features/drawer/presentation/widgets/history.dart';
import 'package:verbisense/features/drawer/presentation/widgets/upload_file.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

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
          const CustomDrawerHeader(),
          const UploadFile(),
          const Divider(),
          const Documents(),
          const Spacer(),
          const History(),
        ],
      ),
    );
  }
}
