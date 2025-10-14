import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/providers/providers.dart';

import 'package:verbisense/features/auth/presentation/provider/auth_provider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:verbisense/features/drawer/presentation/widgets/custom_drawer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  void _handleSignOut() {
    ref.read(authProvider.notifier).signOut();
  }

  void _handlePostLogin() {
    ref.read(authProvider.notifier).askNotificationPermission();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(drawerNotifierProvider.notifier).loadDrawerData();
    });
    _handlePostLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      drawer: Drawer(
        child: CustomDrawer(
          // uploadFile: (File file) {
          //   AppLogger.i('Upload file: ${file.path}');
          //   return Future.value(true);
          // },
          deleteFile: (String url, String fileName) {
            AppLogger.i('Delete file: $fileName from $url');
            return Future.value(true);
          },
          getChatData: (String date) => {},
          activeDate: '',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Screen!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CustomElevatedButton(
              onTap: _handleSignOut,
              text: 'Sign Out',
            ),
          ],
        ),
      ),
    );
  }
}
