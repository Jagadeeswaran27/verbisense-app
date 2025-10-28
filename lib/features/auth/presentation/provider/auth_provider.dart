import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/config/firebase_push_notification.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/auth/data/models/user_model.dart';
import 'package:verbisense/features/auth/domain/repository/firebase_auth_repository.dart';
import 'package:verbisense/features/auth/domain/usecases/create_user.dart';
import 'package:verbisense/features/auth/domain/usecases/email_signin.dart';
import 'package:verbisense/features/auth/domain/usecases/get_current_user.dart';
import 'package:verbisense/features/auth/domain/usecases/google_signin.dart';
import 'package:verbisense/features/auth/domain/usecases/signout.dart';
import 'package:verbisense/features/auth/domain/usecases/update_fcm.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.buttonLoading() = AuthButtonLoading;
  const factory AuthState.success(User user) = AuthSuccess;
  const factory AuthState.error(String message) = AuthError;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthButtonLoading extends AuthState {
  const AuthButtonLoading();
}

class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final CreateUser _createUser;
  final EmailSignin _emailSignin;
  final GoogleSignin _googleSignin;
  final Signout _signout;
  final UpdateFcm _updateFcm;
  final GetCurrentUser _getCurrentUser;
  final FirebaseAuthRepository _authRepository;
  StreamSubscription<firebase_auth.User?>? _authSubscription;

  AuthNotifier(
    this._createUser,
    this._emailSignin,
    this._googleSignin,
    this._signout,
    this._updateFcm,
    this._getCurrentUser,
    this._authRepository,
  ) : super(const AuthState.initial()) {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    _authSubscription = _authRepository.userAuthStateChanges().listen(
      (firebase_auth.User? firebaseUser) async {
        await Future.delayed(const Duration(milliseconds: 1500));
        _handleAuthStateChange(firebaseUser);
      },
      onError: (error) {
        AppLogger.e('Auth state change error: $error');
        state = AuthState.error(error.toString());
      },
    );
  }

  Future<void> _handleAuthStateChange(firebase_auth.User? firebaseUser) async {
    state = const AuthState.loading();
    if (firebaseUser == null) {
      AppLogger.i('User signed out');
      state = const AuthState.initial();
      return;
    }

    final result = await _getCurrentUser(NoParams());

    state = result.fold(
      (error) {
        AppLogger.e('Error getting user data: ${error.message}');
        return AuthState.error(error.message);
      },
      (user) {
        if (user == null) {
          AppLogger.w('User document not found in Firestore');
          return const AuthState.initial();
        }

        AppLogger.i('User authenticated: ${user.email}');
        return AuthState.success(user);
      },
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.buttonLoading();
    final result = await _createUser(
      UserSignupParms(
        name: name,
        email: email,
        password: password,
      ),
    );
    result.fold(
      (failure) {
        AppLogger.e(failure.message);
        state = AuthState.error(failure.message);
      },
      (user) {
        final userModel = user as UserModel;
        AppLogger.i(userModel.toJson().toString());
        state = AuthState.success(userModel);
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.buttonLoading();
    final result = await _emailSignin(
      EmailSigninParams(
        email: email,
        password: password,
      ),
    );
    result.fold(
      (failure) {
        AppLogger.e(failure.message);
        state = AuthState.error(failure.message);
      },
      (user) {
        final userModel = user as UserModel;

        AppLogger.i('Login Success! ${userModel.toJson().toString()}');
        state = AuthState.success(userModel);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.buttonLoading();
    final result = await _googleSignin(NoParams());
    result.fold(
      (failure) {
        AppLogger.e(failure.message);
        state = AuthState.error(failure.message);
      },
      (user) {
        final userModel = user as UserModel;
        AppLogger.i('Login Success! ${userModel.toJson().toString()}');
        state = AuthState.success(userModel);
      },
    );
  }

  Future<void> signOut() async {
    final result = await _signout(NoParams());
    result.fold(
      (failure) {
        AppLogger.e(failure.message);
        state = AuthState.error(failure.message);
      },
      (_) {
        state = const AuthState.initial();
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
          state = AuthState.error(failure.message);
        },
        (_) {},
      );
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    serviceLocator<CreateUser>(),
    serviceLocator<EmailSignin>(),
    serviceLocator<GoogleSignin>(),
    serviceLocator<Signout>(),
    serviceLocator<UpdateFcm>(),
    serviceLocator<GetCurrentUser>(),
    serviceLocator<FirebaseAuthRepository>(),
  );
});
