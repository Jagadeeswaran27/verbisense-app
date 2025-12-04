import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/utils/helper.dart';

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({super.key});

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> {
  late String _currentWelcomeString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentWelcomeString =
        welcomeStrings[Random().nextInt(welcomeStrings.length)];
    _startWelcomeStringAnimation();
  }

  void _startWelcomeStringAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final List<String> availableStrings = welcomeStrings
            .where((string) => string != _currentWelcomeString)
            .toList();

        _currentWelcomeString =
            availableStrings[Random().nextInt(availableStrings.length)];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _currentWelcomeString,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 55,
              fontWeight: FontWeight.w500,
              color: ThemeColors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(CommonStrings.askMeAnything),
        ],
      ),
    );
  }
}
