import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/features/auth/presentation/provider/auth_state_provider.dart';

// in your router provider file

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateStreamProvider);

  return GoRouter(
    initialLocation: AppRoutes.init.path,
    routes: AppRoutes.values.map((e) => e.route).toList(),
    redirect: (context, state) {
      final isAuthenticated = authState.hasValue && authState.value != null;
      final isOnAuthPage = _checkIsOnAuthPage(state.fullPath);

      if (authState.isLoading) {
        return AppRoutes.loading.path;
      }

      if (isAuthenticated && isOnAuthPage) {
        return AppRoutes.home.path;
      }
      if (!isAuthenticated && !isOnAuthPage) {
        return AppRoutes.login.path;
      }

      return null;
    },
    errorBuilder: (context, state) =>
        const Placeholder(), // Replace with a proper error screen
  );
});

// _checkIsOnAuthPage function remains the same

bool _checkIsOnAuthPage(path) {
  return path == AppRoutes.login.path ||
      path == AppRoutes.signup.path ||
      path == AppRoutes.init.path;
}
