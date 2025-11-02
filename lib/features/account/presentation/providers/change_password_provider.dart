import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/features/account/domain/usecases/change_password.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class ChangePasswordState {
  const ChangePasswordState();

  factory ChangePasswordState.initial() = ChangePasswordInitial;
  factory ChangePasswordState.loading() = ChangePasswordLoading;
  factory ChangePasswordState.success(String message) = ChangePasswordSuccess;
  factory ChangePasswordState.failure(String error) = ChangePasswordFailure;
}

class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

class ChangePasswordLoading extends ChangePasswordState {
  const ChangePasswordLoading();
}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message;
  const ChangePasswordSuccess(this.message);
}

class ChangePasswordFailure extends ChangePasswordState {
  final String error;
  const ChangePasswordFailure(this.error);
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  final ChangePassword _changePasswordUsecase;

  ChangePasswordNotifier(this._changePasswordUsecase)
    : super(const ChangePasswordInitial());

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    state = const ChangePasswordLoading();
    final result = await _changePasswordUsecase(
      ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    result.fold(
      (failure) {
        state = ChangePasswordFailure(failure.message);
      },
      (_) {
        state = const ChangePasswordSuccess('Password changed successfully.');
      },
    );
  }
}

final changePasswordProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
      return ChangePasswordNotifier(
        serviceLocator<ChangePassword>(),
      );
    });
