import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/features/auth/presentation/provider/auth_provider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _handleSignOut() {
    ref.read(authProvider.notifier).signOut();
  }

  void _handlePostLogin() {
    ref.read(authProvider.notifier).askNotificationPermission();
  }

  @override
  void initState() {
    super.initState();
    _handlePostLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CustomElevatedButton(
              onTap: _handleSignOut,
              text: 'Sign Out',
            ),
          ],
        ),
      ),
    );
  }
}
