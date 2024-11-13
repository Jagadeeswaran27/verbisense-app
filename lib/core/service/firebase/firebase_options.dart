// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDGhZIj-gUSFI31UwqP1X_9NSo9UuZp-YA',
    appId: '1:406831934655:web:107adc2a6e35a9f9f02a0a',
    messagingSenderId: '406831934655',
    projectId: 'verbisense',
    authDomain: 'verbisense.firebaseapp.com',
    storageBucket: 'verbisense.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDF9C75-78xMSgnEA9AB7r_FgxyDgsCpPI',
    appId: '1:406831934655:android:ed99f6ff047bcbf1f02a0a',
    messagingSenderId: '406831934655',
    projectId: 'verbisense',
    storageBucket: 'verbisense.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAflTXMF9TiIqtzweMcKg0aZ-ffv-3G0Zo',
    appId: '1:406831934655:ios:20cfa34e63fb3ad0f02a0a',
    messagingSenderId: '406831934655',
    projectId: 'verbisense',
    storageBucket: 'verbisense.appspot.com',
    androidClientId: '406831934655-45m0ai4b0a151mp2tvoskrvrbem1ps5g.apps.googleusercontent.com',
    iosClientId: '406831934655-pvo612661cmcr1bvt5od8jdupocncknn.apps.googleusercontent.com',
    iosBundleId: 'com.example.verbisense',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAflTXMF9TiIqtzweMcKg0aZ-ffv-3G0Zo',
    appId: '1:406831934655:ios:20cfa34e63fb3ad0f02a0a',
    messagingSenderId: '406831934655',
    projectId: 'verbisense',
    storageBucket: 'verbisense.appspot.com',
    androidClientId: '406831934655-45m0ai4b0a151mp2tvoskrvrbem1ps5g.apps.googleusercontent.com',
    iosClientId: '406831934655-pvo612661cmcr1bvt5od8jdupocncknn.apps.googleusercontent.com',
    iosBundleId: 'com.example.verbisense',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDGhZIj-gUSFI31UwqP1X_9NSo9UuZp-YA',
    appId: '1:406831934655:web:c5a09d127cd7a763f02a0a',
    messagingSenderId: '406831934655',
    projectId: 'verbisense',
    authDomain: 'verbisense.firebaseapp.com',
    storageBucket: 'verbisense.appspot.com',
  );
}
