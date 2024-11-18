import 'package:flutter/material.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/routes/routes.dart';

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
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Routes.accountScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;

          // Define a scale transition
          final scaleTween = Tween<double>(begin: 0.8, end: 1.0)
              .chain(CurveTween(curve: curve));
          final scaleAnimation = animation.drive(scaleTween);

          // Define a fade transition
          final opacityTween = Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: curve));
          final opacityAnimation = animation.drive(opacityTween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
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
