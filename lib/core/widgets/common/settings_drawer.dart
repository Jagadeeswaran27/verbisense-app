import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/utils/navigation.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    super.key,
    required this.logout,
    required this.closeSettingsDrawer,
  });

  final void Function() closeSettingsDrawer;
  final void Function() logout;

  void navigateToAccount(BuildContext context) {
    closeSettingsDrawer();
    pushToScreen(context, AppRoutes.account.path);
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
              onTap: () => navigateToAccount(context),
              child: const Row(
                children: [
                  Icon(Icons.account_circle_outlined),
                  SizedBox(width: 10),
                  Text(CommonStrings.account),
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
                  Text(CommonStrings.logout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
