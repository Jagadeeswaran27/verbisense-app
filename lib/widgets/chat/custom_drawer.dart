import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verbisense/providers/auth_provider.dart';
import 'package:verbisense/resources/strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:verbisense/themes/colors.dart';
import 'package:verbisense/themes/fonts.dart';
import 'package:verbisense/utils/helper.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.uploadedFiles,
    required this.uploadFile,
    required this.deleteFile,
    required this.chatHistory,
    required this.getChatData,
    required this.activeDate,
  });

  final List<String> uploadedFiles;
  final Future<bool> Function(File file) uploadFile;
  final List<Map<String, String>> chatHistory;
  final Future<bool> Function(String url, String fileName) deleteFile;
  final void Function(String date) getChatData;
  final String activeDate;
  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  List<String> uploadedFileName = [];
  bool isFileUploading = false;
  bool isFileDeleting = false;
  String? error;

  void _pickFile() async {
    if (uploadedFileName.length >= 3) {
      setState(() {
        error = Strings.maxFilesUploaded;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          error = null;
        });
      });
      return;
    }
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (uploadedFileName.length + files.length > 3) {
        setState(() {
          error = Strings.maxFilesUploaded;
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
    setState(() {
      isFileUploading = true;
    });
    final url = await widget.uploadFile(file);
    if (url) {
      setState(() {
        isFileUploading = false;
      });
    }
    setState(() {
      isFileUploading = false;
    });
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
    uploadedFileName = widget.uploadedFiles;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
                Strings.verbisense,
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
                ? Strings.uploading
                : isFileDeleting
                    ? Strings.deleting
                    : Strings.upload,
          ),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          onTap: isFileDeleting || isFileDeleting ? () => {} : _pickFile,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Divider()),
        ListTile(
          leading: const Icon(Icons.document_scanner),
          title: const Text(Strings.documents),
          onTap: () {},
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                Strings.uploadedDocumentsMax3Mb,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              if (uploadedFileName.isNotEmpty)
                for (String fileName in uploadedFileName)
                  Container(
                    color: ThemeColors.white,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenSize.width * 0.55,
                          child: Text(
                            getFilenameFromUrl(fileName),
                            style: Theme.of(context).textTheme.bodySmallBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => openFile(fileName),
                          child: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => handleDeleteFile(
                            fileName,
                            getFilenameFromUrl(fileName),
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
              if (uploadedFileName.isEmpty) const Text(Strings.noFilesUploaded),
              if (error != null)
                Text(
                  error!,
                  style: TextStyle(
                    color: ThemeColors.errorColor,
                  ),
                ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                Strings.history,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => {
                      Navigator.of(context).pop(),
                      widget.getChatData(formatDateAsString()),
                    },
                    child: Text(
                      Strings.today,
                      style: TextStyle(
                        fontWeight: widget.activeDate == formatDateAsString()
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              ...widget.chatHistory.map(
                (history) {
                  var date = history.keys.first;
                  var content = history[date];

                  return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(Icons.calendar_today),
                    title: Text('${formatDate(date)} - $content',
                        style: TextStyle(
                          fontWeight: widget.activeDate == date
                              ? FontWeight.w700
                              : FontWeight.w500,
                        )),
                    onTap: () => {
                      Navigator.pop(context),
                      widget.getChatData(date),
                    },
                    dense: true,
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
