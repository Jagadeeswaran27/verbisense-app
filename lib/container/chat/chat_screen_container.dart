import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/widgets/chat/chat_screen_widget.dart';

class ChatScreenContainer extends StatefulWidget {
  const ChatScreenContainer({super.key});

  @override
  State<ChatScreenContainer> createState() => _ChatScreenContainerState();
}

class _ChatScreenContainerState extends State<ChatScreenContainer> {
  final authService = AuthService();

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
      logout: handleSignOut,
    );
  }
}
