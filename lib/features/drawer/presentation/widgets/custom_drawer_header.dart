import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/utils/navigation.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          CommonStrings.verbisense,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => popScreen(context),
        ),
      ],
    );
  }
}
