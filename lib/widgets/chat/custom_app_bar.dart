import 'package:flutter/material.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/screens/about_us_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.toggleSettingsDrawer,
  });

  final void Function() toggleSettingsDrawer;

  void navigateToAboutUsScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AboutUsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: const Text(Strings.verbisense),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.2),
      actions: [
        Row(
          children: [
            InkWell(
              onTap: () => navigateToAboutUsScreen(context),
              child: const Text(Strings.about),
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(
                Icons.settings,
                size: 30,
              ),
              onPressed: toggleSettingsDrawer,
            ),
          ],
        ),
      ],
    );
  }
}
