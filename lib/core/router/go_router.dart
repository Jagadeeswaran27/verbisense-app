import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:verbisense/core/router/app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.login.path,
  routes: AppRoutes.values.map((e) => e.route).toList(),
  redirect: (context, state) {
    // Example redirect logic
    // if (someCondition) {
    //   return '/somePath';
    // }
    // return AppRoutes.login.path;
    return null;
  },
  errorBuilder: (context, state) => Placeholder(),
);
