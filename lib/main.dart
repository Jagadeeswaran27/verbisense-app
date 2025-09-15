import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:verbisense/core/resources/common_strings.dart';
import 'package:verbisense/firebase_options.dart';

void main() async {
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VerbisenseApp());
}

class VerbisenseApp extends StatelessWidget {
  const VerbisenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CommonStrings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Placeholder(),
    );
  }
}
