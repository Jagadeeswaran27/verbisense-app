import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/providers/auth_core_provider.dart';
import 'package:verbisense/features/account/domain/usecases/update_user_name.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class UpdateUserNameState {
  const UpdateUserNameState();

  const factory UpdateUserNameState.initial() = UpdateUserNameInitial;
  const factory UpdateUserNameState.loading() = UpdateUserNameLoading;
  const factory UpdateUserNameState.success() = UpdateUserNameSuccess;
  const factory UpdateUserNameState.error(String message) = UpdateUserNameError;
}

class UpdateUserNameInitial extends UpdateUserNameState {
  const UpdateUserNameInitial();
}

class UpdateUserNameLoading extends UpdateUserNameState {
  const UpdateUserNameLoading();
}

class UpdateUserNameSuccess extends UpdateUserNameState {
  const UpdateUserNameSuccess();
}

class UpdateUserNameError extends UpdateUserNameState {
  final String message;
  const UpdateUserNameError(this.message);
}

class UpdateUserNameNotifier extends StateNotifier<UpdateUserNameState> {
  final UpdateUserName _updateUserName;
  final Ref _ref;

  UpdateUserNameNotifier(this._updateUserName, this._ref)
    : super(const UpdateUserNameState.initial());

  Future<void> updateName(String name) async {
    state = const UpdateUserNameState.loading();
    final result = await _updateUserName(name);
    result.fold(
      (failure) {
        state = UpdateUserNameState.error(failure.message);
      },
      (_) async {
        state = const UpdateUserNameState.success();
        await _ref.read(authCoreProvider.notifier).refreshUser();
      },
    );
  }
}

final updateUserNameProvider =
    StateNotifierProvider<UpdateUserNameNotifier, UpdateUserNameState>((ref) {
      return UpdateUserNameNotifier(
        serviceLocator<UpdateUserName>(),
        ref,
      );
    });
