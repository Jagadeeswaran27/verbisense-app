import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:verbisense/features/about_us/presentation/screens/about_us_screen.dart';
import 'package:verbisense/features/auth/presentation/screens/get_started_screen.dart';
import 'package:verbisense/features/auth/presentation/screens/init_screen.dart';
import 'package:verbisense/features/auth/presentation/screens/login_screen.dart';
import 'package:verbisense/features/auth/presentation/screens/signup_screen.dart';
import 'package:verbisense/features/chat/presentation/screens/chat_screen.dart';
import 'package:verbisense/core/widgets/common/loading_screen.dart';

enum AppRoutes {
  init,
  getStarted,
  loading,
  login,
  signup,
  chat,
  aboutUs,
}

extension AppRoutesExtension on AppRoutes {
  static const Map<AppRoutes, String> _paths = {
    AppRoutes.init: '/',
    AppRoutes.getStarted: '/get-started',
    AppRoutes.loading: '/loading',
    AppRoutes.signup: '/signup',
    AppRoutes.login: '/login',
    AppRoutes.chat: '/chat',
    AppRoutes.aboutUs: '/about-us',
  };

  static const Map<AppRoutes, String> _names = {
    AppRoutes.init: 'initScreen',
    AppRoutes.getStarted: 'getStarted',
    AppRoutes.loading: 'loading',
    AppRoutes.signup: 'signup',
    AppRoutes.login: 'login',
    AppRoutes.chat: 'chat',
    AppRoutes.aboutUs: 'aboutUs',
  };

  static const Map<AppRoutes, Widget Function()> _builders = {
    AppRoutes.init: InitScreen.new,
    AppRoutes.getStarted: GetStartedScreen.new,
    AppRoutes.loading: LoadingScreen.new,
    AppRoutes.login: LoginScreen.new,
    AppRoutes.signup: SignupScreen.new,
    AppRoutes.chat: ChatScreen.new,
    AppRoutes.aboutUs: AboutUsScreen.new,
  };

  String get path => _paths[this]!;
  String get name => _names[this]!;

  GoRoute get route {
    return GoRoute(
      name: name,
      path: path,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: _builders[this]!(),
        );
      },
    );
  }
}
