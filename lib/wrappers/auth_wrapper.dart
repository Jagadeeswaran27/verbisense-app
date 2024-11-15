import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbisense/providers/auth_provider.dart';
import 'package:verbisense/screens/chat_screen.dart';
import 'package:verbisense/screens/home_screen.dart';
import 'package:verbisense/themes/colors.dart';
import 'package:verbisense/widgets/loaders/dots_triangle/dots_traingle.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: DotsTriangle(size: 70, color: ThemeColors.black),
        ),
      );
    }
    return authProvider.isAuthenticated
        ? const ChatScreen()
        : const HomeScreen();
  }
}
