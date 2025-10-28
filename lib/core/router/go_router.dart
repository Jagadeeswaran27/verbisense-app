import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:verbisense/core/router/app_routes.dart';
import 'package:verbisense/features/auth/presentation/provider/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.init.path,
    routes: AppRoutes.values.map((e) => e.route).toList(),
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState is AuthSuccess;
      final isOnAuthPage = _checkIsOnAuthPage(state.fullPath);

      if (authState is AuthLoading) {
        return AppRoutes.loading.path;
      }

      if (isAuthenticated && isOnAuthPage) {
        return AppRoutes.chat.path;
      }

      if (!isAuthenticated && !isOnAuthPage) {
        return AppRoutes.getStarted.path;
      }

      return null;
    },
    errorBuilder: (context, state) => const Placeholder(),
  );
});

bool _checkIsOnAuthPage(String? path) {
  return path == AppRoutes.login.path ||
      path == AppRoutes.signup.path ||
      path == AppRoutes.init.path ||
      path == AppRoutes.loading.path;
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
