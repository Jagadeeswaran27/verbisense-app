import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/config/firebase_push_notification.dart';
import 'package:verbisense/core/domain/repository/firebase_auth_core_repository.dart';
import 'package:verbisense/core/domain/usecases/get_current_user.dart';
import 'package:verbisense/core/domain/usecases/signout.dart';
import 'package:verbisense/core/domain/usecases/update_fcm.dart';
import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/providers/app_reset_provider.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class AuthCoreState {
  const AuthCoreState();

  const factory AuthCoreState.initial() = AuthCoreInitial;
  const factory AuthCoreState.loading() = AuthCoreLoading;
  const factory AuthCoreState.success(User user) = AuthCoreSuccess;
  const factory AuthCoreState.error(String message) = AuthCoreError;
}

class AuthCoreInitial extends AuthCoreState {
  const AuthCoreInitial();
}

class AuthCoreLoading extends AuthCoreState {
  const AuthCoreLoading();
}

class AuthCoreSuccess extends AuthCoreState {
  final User user;
  const AuthCoreSuccess(this.user);
}

class AuthCoreError extends AuthCoreState {
  final String message;
  const AuthCoreError(this.message);
}

class AuthCoreProviderNotifier extends StateNotifier<AuthCoreState> {
  final GetCurrentUser _getCurrentUser;
  final Signout _signout;
  final UpdateFcm _updateFcm;
  final FirebaseAuthCoreRepository _authRepository;
  late final StreamSubscription<firebase_auth.User?> _authSubscription;
  final Ref _ref;

  AuthCoreProviderNotifier(
    this._getCurrentUser,
    this._signout,
    this._updateFcm,
    this._authRepository,
    this._ref,
  ) : super(const AuthCoreState.initial()) {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authSubscription = _authRepository.userAuthStateChanges().listen(
      (firebase_auth.User? firebaseUser) async {
        await Future.delayed(const Duration(milliseconds: 1000));
        _handleAuthStateChange(firebaseUser);
      },
      onError: (error) {
        AppLogger.e('Auth state change error: $error');
        state = AuthCoreState.error(error.toString());
      },
    );
  }

  Future<void> _handleAuthStateChange(firebase_auth.User? firebaseUser) async {
    state = const AuthCoreState.loading();
    if (firebaseUser == null) {
      AppLogger.i('User signed out');
      state = const AuthCoreState.initial();
      return;
    }

    final result = await _getCurrentUser(NoParams());

    state = result.fold(
      (error) {
        AppLogger.e('Error getting user data: ${error.message}');
        return AuthCoreState.error(error.message);
      },
      (user) {
        AppLogger.i('User authenticated: ${user.email}');
        return AuthCoreState.success(user);
      },
    );
  }

  Future<void> signOut() async {
    final result = await _signout(NoParams());
    result.fold(
      (failure) {
        AppLogger.e(failure.message);
        state = AuthCoreState.error(failure.message);
      },
      (_) {
        _ref.read(appStateResetProvider)(_ref);
        state = const AuthCoreState.initial();
      },
    );
  }

  Future<void> askNotificationPermission() async {
    final token = await FirebasePushNotification().initNotifications();
    if (token != null) {
      final result = await _updateFcm(token);
      result.fold(
        (failure) {
          AppLogger.e(failure.message);
          state = AuthCoreState.error(failure.message);
        },
        (_) {},
      );
    }
  }

  Future<void> refreshUser() async {
    final result = await _getCurrentUser(NoParams());

    result.fold(
      (failure) {
        AppLogger.e('Error refreshing user: ${failure.message}');
        state = AuthCoreState.error(failure.message);
      },
      (user) {
        AppLogger.i('User refreshed: ${user.email}');
        state = AuthCoreState.success(user);
      },
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

final authCoreProvider =
    StateNotifierProvider<AuthCoreProviderNotifier, AuthCoreState>((ref) {
      return AuthCoreProviderNotifier(
        serviceLocator<GetCurrentUser>(),
        serviceLocator<Signout>(),
        serviceLocator<UpdateFcm>(),
        serviceLocator<FirebaseAuthCoreRepository>(),
        ref,
      );
    });
