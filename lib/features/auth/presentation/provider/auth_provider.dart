import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/common/entities/user.dart';
import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/features/auth/data/models/user_model.dart';
import 'package:verbisense/features/auth/domain/usecases/create_user.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.success(User user) = AuthSuccess;
  const factory AuthState.error(String message) = AuthError;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
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

  AuthNotifier(this._createUser) : super(const AuthState.initial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
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
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(serviceLocator<CreateUser>());
});
