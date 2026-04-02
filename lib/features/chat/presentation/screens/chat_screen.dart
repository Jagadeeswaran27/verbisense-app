import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/providers/auth_core_provider.dart';
import 'package:verbisense/core/widgets/common/app_drawer.dart';
import 'package:verbisense/core/widgets/common/custom_app_bar.dart';
import 'package:verbisense/core/widgets/common/settings_drawer.dart';
import 'package:verbisense/features/chat/presentation/widgets/chat_display_widget.dart';
import 'package:verbisense/features/chat/presentation/widgets/chat_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _isSettingsDrawerOpen = false;

  void _toggleSettingsDrawer() {
    setState(() {
      _isSettingsDrawerOpen = !_isSettingsDrawerOpen;
    });
  }

  void _closeSettingsDrawer() {
    setState(() {
      _isSettingsDrawerOpen = false;
    });
  }

  void _handleSignOut() {
    ref.read(authCoreProvider.notifier).signOut();
  }

  void _handlePostLogin() {
    ref.read(authCoreProvider.notifier).askNotificationPermission();
  }

  @override
  void initState() {
    super.initState();
    _handlePostLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(toggleSettingsDrawer: _toggleSettingsDrawer),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_isSettingsDrawerOpen) {
            _closeSettingsDrawer();
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ChatDataDisplayWidget(),
                ),
                ChatInput(),
              ],
            ),
            if (_isSettingsDrawerOpen)
              Positioned(
                top: 5,
                right: 10,
                child: SettingsDrawer(
                  closeSettingsDrawer: _toggleSettingsDrawer,
                  logout: _handleSignOut,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
