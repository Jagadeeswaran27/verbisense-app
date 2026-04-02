import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';

import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/core/usecase/usecase.dart';
import 'package:verbisense/features/file_management/domain/usecases/delete_file.dart';
import 'package:verbisense/features/file_management/domain/usecases/get_uploaded_files.dart';
import 'package:verbisense/features/file_management/domain/usecases/upload_file.dart';
import 'package:verbisense/init_dependencies.dart';

sealed class FileManagementState {
  const FileManagementState();

  const factory FileManagementState.initial() = InitialFileManagementState;
  const factory FileManagementState.loading() = LoadingFileManagementState;
  const factory FileManagementState.loaded({
    required List<String> files,
    required bool isUploading,
    String? uploadError,
    String? deletingFileName,
  }) = LoadedFileManagementState;
  const factory FileManagementState.error(String message) =
      ErrorFileManagementState;
}

class InitialFileManagementState extends FileManagementState {
  const InitialFileManagementState();
}

class LoadingFileManagementState extends FileManagementState {
  const LoadingFileManagementState();
}

class LoadedFileManagementState extends FileManagementState {
  final List<String> files;
  final bool isUploading;
  final String? uploadError;
  final String? deletingFileName;

  const LoadedFileManagementState({
    required this.files,
    required this.isUploading,
    this.uploadError,
    this.deletingFileName,
  });

  LoadedFileManagementState copyWith({
    List<String>? files,
    bool? isUploading,
    String? uploadError,
    String? deletingFileName,
  }) {
    return LoadedFileManagementState(
      files: files ?? this.files,
      isUploading: isUploading ?? this.isUploading,
      uploadError: uploadError,
      deletingFileName: deletingFileName,
    );
  }

  LoadedFileManagementState clearUploadError() {
    return copyWith(uploadError: null);
  }
}

class ErrorFileManagementState extends FileManagementState {
  final String message;
  const ErrorFileManagementState(this.message);
}

class FileManagementNotifier extends StateNotifier<FileManagementState> {
  FileManagementNotifier(
    this._getUploadedFiles,
    this._uploadFile,
    this._deleteFile,
  ) : super(const FileManagementState.initial()) {
    loadFileManagementData();
  }
  final GetUploadedFiles _getUploadedFiles;
  final UploadFile _uploadFile;
  final DeleteFile _deleteFile;

  Future<void> loadFileManagementData() async {
    state = const FileManagementState.loading();

    final result = await _getUploadedFiles.call(NoParams());

    result.fold(
      (failure) {
        state = FileManagementState.error(failure.message);
      },
      (files) {
        state = FileManagementState.loaded(
          files: files,
          isUploading: false,
        );
      },
    );
  }

  Future<void> uploadFile(File file) async {
    final result = await _uploadFile.call(file);
    result.fold(
      (failure) {
        if (state is LoadedFileManagementState) {
          final currentState = state as LoadedFileManagementState;
          state = currentState.copyWith(
            isUploading: false,
            uploadError: '${failure.message} for ${file.path.split('/').last}',
          );
        }
        AppLogger.e('File upload failed: $failure');
      },
      (fileUrl) {
        if (state is LoadedFileManagementState) {
          final currentState = state as LoadedFileManagementState;
          final updatedFiles = [...currentState.files, fileUrl];
          state = currentState.copyWith(files: updatedFiles);
        }
        AppLogger.i('File uploaded successfully: $fileUrl');
      },
    );
  }

  Future<void> uploadFiles(List<File> files) async {
    if (state is! LoadedFileManagementState) return;

    final currentState = state as LoadedFileManagementState;
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
        if (state is LoadedFileManagementState) {
          final currentState = state as LoadedFileManagementState;
          state = currentState.copyWith(
            isUploading: files.indexOf(file) == files.length - 1 ? false : true,
            uploadError:
                'File ${file.path.split('/').last} is too large.${files.indexOf(file) < files.length - 1 ? ' Moving to next file.' : ''}',
          );
        }
        _clearUploadError();
        continue;
      }
      final fileName = file.path.split('/').last;
      if (currentState.files.any(
        (file) => Uri.decodeComponent(file).contains(fileName),
      )) {
        if (state is LoadedFileManagementState) {
          final currentState = state as LoadedFileManagementState;
          state = currentState.copyWith(
            isUploading: files.indexOf(file) == files.length - 1 ? false : true,
            uploadError: 'File $fileName is already uploaded.',
          );
        }
        _clearUploadError();
        continue;
      }
      await uploadFile(file);
    }
    AppLogger.i('Finished uploading files.');
    final updatedState = state as LoadedFileManagementState;
    state = updatedState.copyWith(
      isUploading: false,
      uploadError: updatedState.uploadError,
    );
  }

  void _clearUploadError() {
    Future.delayed(const Duration(seconds: 3), () {
      if (state is LoadedFileManagementState) {
        final currentState = state as LoadedFileManagementState;
        state = currentState.clearUploadError();
      }
    });
  }

  Future<void> deleteFile(String fileName) async {
    if (state is! LoadedFileManagementState) return;

    final currentState = state as LoadedFileManagementState;
    state = currentState.copyWith(deletingFileName: fileName);

    final result = await _deleteFile.call(fileName);
    result.fold(
      (failure) {
        AppLogger.e('File deletion failed: ${failure.message}');
      },
      (_) {
        if (state is LoadedFileManagementState) {
          final currentState = state as LoadedFileManagementState;
          AppLogger.i('Current files before deletion: ${currentState.files}');
          AppLogger.i('Deleting file: $fileName');
          final updatedFiles = currentState.files
              .where((file) => !Uri.decodeComponent(file).contains(fileName))
              .toList();
          AppLogger.i('Updated files after deletion: $updatedFiles');
          state = currentState.copyWith(files: updatedFiles);
        }
        AppLogger.i('File deleted successfully: $fileName');
      },
    );

    if (state is LoadedFileManagementState) {
      final currentState = state as LoadedFileManagementState;
      state = currentState.copyWith(deletingFileName: null);
    }
  }
}

final fileManagementNotifierProvider =
    StateNotifierProvider<FileManagementNotifier, FileManagementState>((ref) {
      return FileManagementNotifier(
        serviceLocator<GetUploadedFiles>(),
        serviceLocator<UploadFile>(),
        serviceLocator<DeleteFile>(),
      );
    });
