import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbisense/providers/auth_provider.dart';
import 'package:verbisense/screens/chat_screen.dart';
import 'package:verbisense/screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return authProvider.isAuthenticated
        ? const ChatScreen()
        : const HomeScreen();
  }
}
