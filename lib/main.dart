import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:verbisense/app.dart';
import 'package:verbisense/core/service/firebase/firebase_options.dart';
import 'package:verbisense/utils/deep_link_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeepLinkHandler.initUniLinks();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VerbisenseApp());
}
