import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verbisense/features/auth/presentation/provider/auth_provider.dart';
import 'package:verbisense/features/auth/presentation/widgets/custom_elevated_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleSignOut() {
      ref.read(authProvider.notifier).signOut();
    }

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
              onTap: handleSignOut,
              text: 'Sign Out',
            ),
          ],
        ),
      ),
    );
  }
}
