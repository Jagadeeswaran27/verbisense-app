import 'package:flutter/material.dart';
import 'package:verbisense/core/service/auth/auth_service.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/widgets/common/custom_elevated_button.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void handleLogout() async {
      final authService = AuthService();
      await authService.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.init,
        (Route<dynamic> route) => false,
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Chat Screen"),
            CustomElevatedButton(onTap: handleLogout, text: "Logout"),
          ],
        ),
      ),
    );
  }
}
