import 'package:flutter/material.dart';

import 'package:verbisense/screens/chat_screen.dart';
import 'package:verbisense/screens/home_screen.dart';
import 'package:verbisense/screens/login_screen.dart';
import 'package:verbisense/screens/signup_screen.dart';
import 'package:verbisense/wrappers/auth_wrapper.dart';

class Routes {
  const Routes._();

  static const String wrapper = '/wrapper';
  static const String init = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String chat = '/chat';
  static Map<String, WidgetBuilder> get buildRoutes {
    return {
      wrapper: (context) => const AuthWrapper(),
      init: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      chat: (context) => const ChatScreen()
    };
  }

  static String get initialRoute => wrapper;
  static Widget get initialScreen => const AuthWrapper();
}
