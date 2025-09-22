import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/features/auth/presentation/provider/auth_state_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateStreamProvider);

  return GoRouter(
    initialLocation: AppRoutes.init.path,
    routes: AppRoutes.values.map((e) => e.route).toList(),
    redirect: (context, state) {
      AppLogger.i('Auth State Changed: $authState');

      return authState.when(
        data: (user) {
          final isAuthenticated = user != null;
          final isOnAuthPage = _checkIsOnAuthPage(state.fullPath);

          if (isAuthenticated && isOnAuthPage) {
            return AppRoutes.home.path;
          }
          if (!isAuthenticated && !isOnAuthPage) {
            return AppRoutes.login.path;
          }

          return null;
        },
        error: (error, stackTrace) => AppRoutes.login.path,
        loading: () => AppRoutes.loading.path,
      );
    },
    errorBuilder: (context, state) => Placeholder(),
  );
});

bool _checkIsOnAuthPage(path) {
  return path == AppRoutes.login.path ||
      path == AppRoutes.signup.path ||
      path == AppRoutes.init.path;
}
