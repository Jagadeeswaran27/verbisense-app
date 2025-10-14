import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/router/go_router.dart';
import 'package:verbisense/core/themes/app_theme.dart';
import 'package:verbisense/init_dependencies.main.dart';

void main() async {
  AppLogger.i('App Started!');
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    const ProviderScope(
      child: VerbisenseApp(),
    ),
  );
}

class VerbisenseApp extends ConsumerWidget {
  const VerbisenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: CommonStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLightTheme(context),
      routerConfig: router,
    );
  }
}
