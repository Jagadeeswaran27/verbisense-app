import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/account/domain/usecases/get_user_provider_info.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class ProviderInfoState {
  const ProviderInfoState();

  const factory ProviderInfoState.initial() = ProviderInfoInitial;
  const factory ProviderInfoState.loading() = ProviderInfoLoading;
  const factory ProviderInfoState.loaded(List<String> providers) =
      ProviderInfoLoaded;
  const factory ProviderInfoState.error(String message) = ProviderInfoError;
}

class ProviderInfoInitial extends ProviderInfoState {
  const ProviderInfoInitial();
}

class ProviderInfoLoading extends ProviderInfoState {
  const ProviderInfoLoading();
}

class ProviderInfoLoaded extends ProviderInfoState {
  final List<String> providers;
  const ProviderInfoLoaded(this.providers);
}

class ProviderInfoError extends ProviderInfoState {
  final String message;
  const ProviderInfoError(this.message);
}

class ProviderInfoProvider extends StateNotifier<ProviderInfoState> {
  final GetUserProviderInfo _getUserProviderInfo;

  ProviderInfoProvider(this._getUserProviderInfo)
    : super(const ProviderInfoState.initial()) {
    _fetchUserProviderInfo();
  }

  void _fetchUserProviderInfo() async {
    state = const ProviderInfoState.loading();
    final result = await _getUserProviderInfo(NoParams());
    result.fold(
      (failure) {
        AppLogger.e('Error fetching user provider info: ${failure.message}');
        state = ProviderInfoState.error(failure.message);
      },
      (providers) {
        state = ProviderInfoState.loaded(providers);
      },
    );
  }
}

final providerInfoProvider =
    StateNotifierProvider<ProviderInfoProvider, ProviderInfoState>((ref) {
      return ProviderInfoProvider(
        serviceLocator<GetUserProviderInfo>(),
      );
    });
