import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/utils/navigation.dart';
import 'package:verbisense/core/themes/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.toggleSettingsDrawer,
  });

  final void Function() toggleSettingsDrawer;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: const Text(CommonStrings.verbisense),
      elevation: 4.0,
      shadowColor: ThemeColors.black.withOpacityValue(0.2),
      actions: [
        Row(
          children: [
            InkWell(
              onTap: () => pushToScreen(context, AppRoutes.aboutUs.path),
              child: const Text(CommonStrings.about),
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
