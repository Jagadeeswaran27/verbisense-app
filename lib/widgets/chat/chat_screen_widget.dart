import 'dart:io';

import 'package:flutter/material.dart';
import 'package:verbisense/model/chat_model.dart';
import 'package:verbisense/widgets/chat/chat_data_display_widget.dart';
import 'package:verbisense/widgets/chat/custom_app_bar.dart';
import 'package:verbisense/widgets/chat/custom_drawer.dart';
import 'package:verbisense/widgets/chat/settings_drawer.dart';
import 'package:verbisense/widgets/chat/chat_input.dart';
import 'package:verbisense/widgets/chat/welcome_string_widget.dart';

class ChatScreenWidget extends StatefulWidget {
  const ChatScreenWidget({
    super.key,
    required this.logout,
    required this.uploadedFiles,
    required this.chatMessages,
    required this.uploadFile,
    required this.deleteFile,
    required this.chatHistory,
    required this.getChatData,
    required this.sendChatData,
    required this.activeDate,
    required this.isSending,
  });

  final void Function() logout;
  final List<String> uploadedFiles;
  final List<ChatModel> chatMessages;
  final List<Map<String, String>> chatHistory;
  final void Function(String message) sendChatData;
  final String activeDate;
  final bool isSending;
  final Future<bool> Function(File file) uploadFile;
  final Future<bool> Function(String url, String fileName) deleteFile;
  final void Function(String date) getChatData;

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _closeSettingsDrawer();
      },
      child: Scaffold(
        drawer: Drawer(
          child: CustomDrawer(
            chatHistory: widget.chatHistory,
            deleteFile: widget.deleteFile,
            uploadFile: widget.uploadFile,
            uploadedFiles: widget.uploadedFiles,
            getChatData: widget.getChatData,
            activeDate: widget.activeDate,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(toggleSettingsDrawer: _toggleSettingsDrawer),
                Expanded(
                  child: widget.chatMessages.isEmpty
                      ? const WelcomeStringWidget()
                      : ChatDataDisplayWidget(
                          isSending: widget.isSending,
                          chatMessages: widget.chatMessages,
                        ),
                ),
                ChatInput(
                  sendChatData: widget.sendChatData,
                ),
              ],
            ),
            if (_isSettingsDrawerOpen)
              Positioned(
                top: kToolbarHeight + 30,
                right: 26,
                child: SettingsDrawer(
                  closeSettingsDrawer: _closeSettingsDrawer,
                  logout: widget.logout,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
