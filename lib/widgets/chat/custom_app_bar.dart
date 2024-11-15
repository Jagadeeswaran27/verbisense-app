import 'package:flutter/material.dart';
import 'package:verbisense/resources/strings.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.toggleSettingsDrawer,
  });
  final void Function() toggleSettingsDrawer;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: const Text(Strings.verbisense),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.2), // Customize the shadow color
      actions: [
        Row(
          children: [
            const Text(Strings.about),
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
