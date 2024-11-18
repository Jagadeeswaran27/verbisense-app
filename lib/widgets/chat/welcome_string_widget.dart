import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:verbisense/themes/colors.dart';
import 'package:verbisense/utils/helper.dart';

class WelcomeStringWidget extends StatefulWidget {
  const WelcomeStringWidget({super.key});

  @override
  State<WelcomeStringWidget> createState() => _WelcomeStringWidgetState();
}

class _WelcomeStringWidgetState extends State<WelcomeStringWidget> {
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
          const Text(Strings.askMeAnything)
        ],
      ),
    );
  }
}
