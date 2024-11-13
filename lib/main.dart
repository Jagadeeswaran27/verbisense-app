import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:verbisense/app.dart';
import 'package:verbisense/core/service/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VerbisenseApp());
}
