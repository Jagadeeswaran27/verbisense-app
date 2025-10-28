import 'package:flutter/material.dart';

import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/navigation.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        goToScreen(context, AppRoutes.getStarted.path);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Name
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Verbi',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 42,
                      letterSpacing: -1.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Sense',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w300,
                      fontSize: 42,
                      letterSpacing: -1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Doc Intelligence',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black45,
                fontWeight: FontWeight.w400,
                letterSpacing: 2,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 80),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(0),
                const SizedBox(width: 8),
                _buildDot(1),
                const SizedBox(width: 8),
                _buildDot(2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue =
            (_animationController.value + (index * 0.2)) % 1.0;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeColors.black.withOpacityValue(
              0.2 + (animationValue * 0.5),
            ),
          ),
        );
      },
    );
  }
}
