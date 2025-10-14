import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/drawer/data/models/history_model.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_chat_history.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_uploaded_files.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class DrawerState {
  const DrawerState();

  const factory DrawerState.initial() = InitialDrawerState;
  const factory DrawerState.loading() = LoadingDrawerState;
  const factory DrawerState.loaded({
    required List<String> files,
    required List<HistoryModel> history,
  }) = LoadedDrawerState;
  const factory DrawerState.error(String message) = ErrorDrawerState;
}

class InitialDrawerState extends DrawerState {
  const InitialDrawerState();
}

class LoadingDrawerState extends DrawerState {
  const LoadingDrawerState();
}

class LoadedDrawerState extends DrawerState {
  final List<String> files;
  final List<HistoryModel> history;
  const LoadedDrawerState({
    required this.files,
    required this.history,
  });
}

class ErrorDrawerState extends DrawerState {
  final String message;
  const ErrorDrawerState(this.message);
}

class DrawerNotifier extends StateNotifier<DrawerState> {
  DrawerNotifier(
    this._getUploadedFiles,
    this._getChatHistories,
  ) : super(const DrawerState.initial());
  final GetUploadedFiles _getUploadedFiles;
  final GetChatHistory _getChatHistories;

  Future<void> loadDrawerData() async {
    state = const DrawerState.loading();

    final results = await Future.wait([
      _getUploadedFiles.call(NoParams()),
      _getChatHistories.call(NoParams()),
    ]);

    final files = results[0].fold(
      (failure) => <String>[],
      (files) => files as List<String>,
    );

    final history = results[1].fold(
      (failure) => <HistoryModel>[],
      (history) => history,
    );

    state = DrawerState.loaded(
      files: files,
      history: history as List<HistoryModel>,
    );

    AppLogger.i('Loaded files: $files');
    AppLogger.i(
      'Loaded chat history: ${history.map((e) => e.toJson()).toList()}',
    );
  }
}

final drawerNotifierProvider =
    StateNotifierProvider<DrawerNotifier, DrawerState>((ref) {
      return DrawerNotifier(
        serviceLocator<GetUploadedFiles>(),
        serviceLocator<GetChatHistory>(),
      );
    });
