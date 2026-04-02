import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:verbisense/core/widgets/common/action_row.dart';
import 'package:verbisense/core/config/app_logger.dart';
import 'package:verbisense/features/file_management/presentation/providers/file_management_provider.dart';

class FileUploadWidget extends ConsumerStatefulWidget {
  const FileUploadWidget({super.key});

  @override
  ConsumerState<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends ConsumerState<FileUploadWidget> {
  String? uploadFileError;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      ref.read(fileManagementNotifierProvider.notifier).uploadFiles(files);
    }
  }

  String _getUploadText(FileManagementState drawerState) {
    return drawerState is LoadedFileManagementState && drawerState.isUploading
        ? 'Uploading'
        : 'Upload File';
  }

  String? _getUploadError(FileManagementState drawerState) {
    if (drawerState is LoadedFileManagementState) {
      return drawerState.uploadError;
    }
    return null;
  }

  bool _getIsDisabled(FileManagementState drawerState) {
    return drawerState is LoadedFileManagementState && drawerState.isUploading;
  }

  @override
  Widget build(BuildContext context) {
    final drawerState = ref.watch(fileManagementNotifierProvider);
    final bool isDisabled = _getIsDisabled(drawerState);
    final String uploadText = _getUploadText(drawerState);
    final String? uploadFileError = _getUploadError(drawerState);
    AppLogger.i(uploadFileError ?? 'No upload error');

    return Column(
      children: [
        ActionRow(
          icon: Icons.upload,
          text: uploadText,
          isDisabled: isDisabled,
          onTap: _pickFile,
        ),
        if (uploadFileError != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.red.shade200, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red.shade600,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    uploadFileError,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
