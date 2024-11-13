import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbisense/providers/auth_provider.dart';
import 'package:verbisense/routes/routes.dart';
import 'package:verbisense/themes/themes.dart';

class VerbisenseApp extends StatelessWidget {
  const VerbisenseApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes.buildLightTheme(context),
        routes: Routes.buildRoutes,
        initialRoute: Routes.initialRoute,
      ),
    );
  }
}
