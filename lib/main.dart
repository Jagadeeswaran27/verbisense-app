import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/resources/common_strings.dart';
import 'package:verbisense/core/router/go_router.dart';
import 'package:verbisense/core/themes/app_theme.dart';
import 'package:verbisense/firebase_options.dart';

void main() async {
  AppLogger.i('App Started!');
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VerbisenseApp());
}

class VerbisenseApp extends StatelessWidget {
  const VerbisenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: CommonStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLightTheme(context),
      routerConfig: router,
    );
  }
}
