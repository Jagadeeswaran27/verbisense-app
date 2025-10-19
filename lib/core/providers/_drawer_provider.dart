import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/drawer/data/models/history_model.dart';
import 'package:verbisense/features/drawer/domain/usecases/delete_file.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_chat_history.dart';
import 'package:verbisense/features/drawer/domain/usecases/get_uploaded_files.dart';
import 'package:verbisense/features/drawer/domain/usecases/upload_file.dart';
import 'package:verbisense/init_dependencies.main.dart';

sealed class DrawerState {
  const DrawerState();

  const factory DrawerState.initial() = InitialDrawerState;
  const factory DrawerState.loading() = LoadingDrawerState;
  const factory DrawerState.loaded({
    required List<String> files,
    required List<HistoryModel> history,
    required bool isUploading,
    String? uploadError,
    String? deletingFileName,
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
  final bool isUploading;
  final String? uploadError;
  final String? deletingFileName;

  const LoadedDrawerState({
    required this.files,
    required this.history,
    this.isUploading = false,
    this.uploadError,
    this.deletingFileName,
  });

  LoadedDrawerState copyWith({
    List<String>? files,
    List<HistoryModel>? history,
    bool? isUploading,
    String? uploadError,
    String? deletingFileName,
  }) {
    return LoadedDrawerState(
      files: files ?? this.files,
      history: history ?? this.history,
      isUploading: isUploading ?? this.isUploading,
      uploadError: uploadError,
      deletingFileName: deletingFileName,
    );
  }

  LoadedDrawerState clearUploadError() {
    return copyWith(uploadError: null);
  }
}

class ErrorDrawerState extends DrawerState {
  final String message;
  const ErrorDrawerState(this.message);
}

class DrawerNotifier extends StateNotifier<DrawerState> {
  DrawerNotifier(
    this._getUploadedFiles,
    this._getChatHistories,
    this._uploadFile,
    this._deleteFile,
  ) : super(const DrawerState.initial());
  final GetUploadedFiles _getUploadedFiles;
  final GetChatHistory _getChatHistories;
  final UploadFile _uploadFile;
  final DeleteFile _deleteFile;

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
      isUploading: false,
    );

    AppLogger.i('Loaded files: $files');
    AppLogger.i(
      'Loaded chat history: ${history.map((e) => e.toJson()).toList()}',
    );
  }

  Future<void> uploadFiles(List<File> files) async {
    if (state is! LoadedDrawerState) return;

    final currentState = state as LoadedDrawerState;
    final currentFileCount = currentState.files.length;

    if (currentFileCount >= 3) {
      state = currentState.copyWith(
        uploadError: DrawerStrings.maxFilesUploaded,
      );
      _clearUploadError();
      return;
    }

    if (currentFileCount + files.length > 3) {
      final remainingSlots = 3 - currentFileCount;
      state = currentState.copyWith(
        uploadError:
            '${DrawerStrings.maxFilesUploaded}. You can upload $remainingSlots more file(s).',
      );
      _clearUploadError();
      return;
    }

    state = currentState.copyWith(isUploading: true, uploadError: null);

    for (File file in files) {
      if (file.lengthSync() > 3 * 1024 * 1024) {
        // 3MB limit
        if (state is LoadedDrawerState) {
          final currentState = state as LoadedDrawerState;
          state = currentState.copyWith(
            isUploading: false,
            uploadError:
                'File ${file.path.split('/').last} is too large.${files.indexOf(file) < files.length - 1 ? ' Moving to next file.' : ''}',
          );
        }
        _clearUploadError();
        continue;
      }
      await uploadFile(file);
    }
    final updatedState = state as LoadedDrawerState;
    state = updatedState.copyWith(isUploading: false);
  }

  Future<void> uploadFile(File file) async {
    final result = await _uploadFile.call(file);
    result.fold(
      (failure) {
        if (state is LoadedDrawerState) {
          final currentState = state as LoadedDrawerState;
          state = currentState.copyWith(
            isUploading: false,
            uploadError: '${failure.message} for ${file.path.split('/').last}',
          );
        }
        AppLogger.e('File upload failed: $failure');
      },
      (fileUrl) {
        if (state is LoadedDrawerState) {
          final currentState = state as LoadedDrawerState;
          final updatedFiles = [...currentState.files, fileUrl];
          state = currentState.copyWith(files: updatedFiles);
        }
        AppLogger.i('File uploaded successfully: $fileUrl');
      },
    );
  }

  Future<void> deleteFile(String fileName) async {
    if (state is! LoadedDrawerState) return;

    final currentState = state as LoadedDrawerState;
    state = currentState.copyWith(deletingFileName: fileName);

    final result = await _deleteFile.call(fileName);
    result.fold(
      (failure) {
        AppLogger.e('File deletion failed: $failure');
      },
      (_) {
        if (state is LoadedDrawerState) {
          final currentState = state as LoadedDrawerState;
          final updatedFiles = currentState.files
              .where((file) => !file.contains(fileName))
              .toList();
          state = currentState.copyWith(files: updatedFiles);
        }
        AppLogger.i('File deleted successfully: $fileName');
      },
    );

    if (state is LoadedDrawerState) {
      final currentState = state as LoadedDrawerState;
      state = currentState.copyWith(deletingFileName: null);
    }
  }

  void _clearUploadError() {
    Future.delayed(const Duration(seconds: 3), () {
      if (state is LoadedDrawerState) {
        final currentState = state as LoadedDrawerState;
        state = currentState.clearUploadError();
      }
    });
  }
}

final drawerNotifierProvider =
    StateNotifierProvider<DrawerNotifier, DrawerState>((ref) {
      return DrawerNotifier(
        serviceLocator<GetUploadedFiles>(),
        serviceLocator<GetChatHistory>(),
        serviceLocator<UploadFile>(),
        serviceLocator<DeleteFile>(),
      );
    });
