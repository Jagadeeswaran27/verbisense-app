import 'package:flutter/material.dart';

import 'package:verbisense/core/entities/user.dart';

class GoogleUserAvatar extends StatelessWidget {
  final User user;

  const GoogleUserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        user.photoURL != null
            ? CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                  user.photoURL!,
                ),
              )
            : const Icon(
                Icons.account_circle,
                size: 50.0,
              ),
        const SizedBox(height: 16),
      ],
    );
  }
}
