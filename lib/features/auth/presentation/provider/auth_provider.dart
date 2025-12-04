import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:verbisense/core/entities/user.dart';
import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/auth/data/models/user_model.dart';
import 'package:verbisense/features/auth/domain/usecases/create_user.dart';
import 'package:verbisense/features/auth/domain/usecases/email_signin.dart';
import 'package:verbisense/features/auth/domain/usecases/google_signin.dart';
import 'package:verbisense/init_dependencies.dart';

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
  StreamSubscription<firebase_auth.User?>? _authSubscription;

  AuthNotifier(
    this._createUser,
    this._emailSignin,
    this._googleSignin,
  ) : super(const AuthState.initial());

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
  );
});
