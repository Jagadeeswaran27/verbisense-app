import 'dart:io';

import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/core/service/chat/chat_service.dart';
import 'package:verbisense/model/chat_model.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/utils/helper.dart';
import 'package:verbisense/widgets/chat/chat_screen_widget.dart';
import 'package:verbisense/widgets/common/custom_snackbar.dart';

class ChatScreenContainer extends StatefulWidget {
  const ChatScreenContainer({super.key});

  @override
  State<ChatScreenContainer> createState() => _ChatScreenContainerState();
}

class _ChatScreenContainerState extends State<ChatScreenContainer> {
  final authService = AuthService();
  final chatService = ChatService();
  bool isSending = false;
  String activeDate = '';
  List<ChatModel> chatMessages = [];
  List<String> uploadedFiles = [];
  List<Map<String, String>> chatHistory = [];

  @override
  void initState() {
    super.initState();
    getFiles();
    getHistory();
    getChatData(formatDateAsString());
  }

  void getChatData(String date) async {
    final chatData = await chatService.getChatData(date);
    setState(() {
      activeDate = date;
      chatMessages = chatData;
    });
  }

  void sendChatData(String message) async {
    setState(() {
      chatMessages.add(ChatModel(
          query: message,
          heading2: [],
          keyTakeaways: '',
          points: Points(points: {}),
          example: [],
          summary: '',
          error: ''));
    });
    setState(() {
      isSending = true;
    });
    final chatData =
        await chatService.sendMessage(message, uploadedFiles, activeDate);
    if (chatData != null) {
      setState(() {
        chatMessages.removeAt(chatMessages.length - 1);
        chatMessages.add(chatData);
        isSending = false;
      });
      return;
    }
    setState(() {
      chatMessages.removeAt(chatMessages.length - 1);
      isSending = false;
      showCustomSnackBar(context, "Failed to get the response");
    });
  }

  void getHistory() async {
    final chatData = await chatService.getHistory();
    if (chatData != null) {
      setState(() {
        chatHistory = chatData;
      });
    }
  }

  void getFiles() async {
    final files = await chatService.getFiles();
    if (files != null) {
      setState(() {
        uploadedFiles = files;
      });
    }
  }

  Future<bool> handleUploadFile(File file) async {
    final url = await chatService.uploadFile(file);
    if (url != null) {
      setState(() {
        uploadedFiles.add(url);
      });
      return true;
    }
    return false;
  }

  Future<bool> handleDeleteFile(String url, String fileName) async {
    final success = await chatService.deleteFile(fileName);
    if (success) {
      setState(() {
        uploadedFiles.remove(url);
      });
      return true;
    }
    return false;
  }

  void handleSignOut() async {
    await authService.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.init,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreenWidget(
      sendChatData: sendChatData,
      logout: handleSignOut,
      isSending: isSending,
      chatHistory: chatHistory,
      activeDate: activeDate,
      chatMessages: chatMessages,
      uploadFile: handleUploadFile,
      deleteFile: handleDeleteFile,
      getChatData: getChatData,
      uploadedFiles: uploadedFiles,
    );
  }
}
