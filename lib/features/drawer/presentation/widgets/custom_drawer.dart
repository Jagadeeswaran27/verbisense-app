import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:verbisense/core/resources/strings/common_strings.dart';
import 'package:verbisense/core/resources/strings/drawer_strings.dart';
import 'package:verbisense/features/drawer/presentation/widgets/documents.dart';
import 'package:verbisense/features/drawer/presentation/widgets/history.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({
    super.key,
    required this.deleteFile,
    required this.getChatData,
    required this.activeDate,
  });

  final Future<bool> Function(String url, String fileName) deleteFile;
  final void Function(String date) getChatData;
  final String activeDate;
  @override
  ConsumerState createState() => CustomDrawerState();
}

class CustomDrawerState extends ConsumerState<CustomDrawer> {
  List<String> uploadedFileName = [];
  bool isFileUploading = false;
  bool isFileDeleting = false;
  String? error;

  void _pickFile() async {
    if (uploadedFileName.length >= 3) {
      setState(() {
        error = DrawerStrings.maxFilesUploaded;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          error = null;
        });
      });
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (uploadedFileName.length + files.length > 3) {
        setState(() {
          error = DrawerStrings.maxFilesUploaded;
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            error = null;
          });
        });
        return;
      }
      for (File file in files) {
        handleUploadFile(file);
      }
    }
  }

  void handleDeleteFile(String url, String fileName) async {
    setState(() {
      isFileDeleting = true;
    });
    final success = await widget.deleteFile(url, fileName);
    if (success) {
      setState(() {
        uploadedFileName.remove(url);
      });
    }
    setState(() {
      isFileDeleting = false;
    });
  }

  void handleUploadFile(File file) async {
    // setState(() {
    //   isFileUploading = true;
    // });
    // final url = await widget.uploadFile(file);
    // if (url) {
    //   setState(() {
    //     isFileUploading = false;
    //   });
    // }
    // setState(() {
    //   isFileUploading = false;
    // });
  }

  Future<void> openFile(String url) async {
    try {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
      throw 'Error opening file: $e';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 40,
            left: 16,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                CommonStrings.verbisense,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.upload),
          title: Text(
            isFileUploading
                ? DrawerStrings.uploading
                : isFileDeleting
                ? DrawerStrings.deleting
                : DrawerStrings.upload,
          ),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          onTap: isFileDeleting || isFileDeleting ? () => {} : _pickFile,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Divider(),
        ),
        const Documents(),
        const Spacer(),
        const History(),
      ],
    );
  }
}
