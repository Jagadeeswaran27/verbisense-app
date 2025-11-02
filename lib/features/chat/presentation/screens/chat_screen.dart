import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verbisense/core/providers/auth_core_provider.dart';

import 'package:verbisense/core/widgets/common/custom_app_bar.dart';
import 'package:verbisense/core/widgets/common/settings_drawer.dart';
import 'package:verbisense/features/chat/presentation/widgets/chat_input.dart';
import 'package:verbisense/features/drawer/presentation/widgets/custom_drawer.dart';

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
        child: CustomDrawer(),
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
                // Expanded(
                //   child: widget.chatMessages.isEmpty
                //       ? const WelcomeStringWidget()
                //       : ChatDataDisplayWidget(
                //           isSending: widget.isSending,
                //           chatMessages: widget.chatMessages,
                //         ),
                // ),
                Expanded(
                  child: Container(), // Placeholder for chat messages
                ),
                ChatInput(
                  sendChatData: (String s) {},
                ),
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
