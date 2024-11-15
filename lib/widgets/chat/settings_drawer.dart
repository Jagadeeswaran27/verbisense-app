import 'package:flutter/material.dart';
import 'package:verbisense/resources/strings.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key, required this.logout});
  final void Function() logout;
  void navigateToAccount() {
    // Navigate to the account screen
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: navigateToAccount,
              child: const Row(
                children: [
                  Icon(Icons.account_circle_outlined),
                  SizedBox(width: 10),
                  Text(Strings.account),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: logout,
              child: const Row(
                children: [
                  Icon(Icons.logout_outlined),
                  SizedBox(width: 10),
                  Text(Strings.logout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
