import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String _getRequiredEnvVar(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Required environment variable $key is not set');
    }
    return value;
  }

  // Firebase Android Keys
  static String get firebaseAndroidApiKey =>
      _getRequiredEnvVar('FIREBASE_ANDROID_API_KEY');

  static String get firebaseAndroidAppId =>
      _getRequiredEnvVar('FIREBASE_ANDROID_APP_ID');

  static String get firebaseAndroidMessagingSenderId =>
      _getRequiredEnvVar('FIREBASE_ANDROID_MESSAGING_SENDER_ID');

  static String get firebaseAndroidProjectId =>
      _getRequiredEnvVar('FIREBASE_ANDROID_PROJECT_ID');

  static String get firebaseAndroidStorageBucket =>
      _getRequiredEnvVar('FIREBASE_ANDROID_STORAGE_BUCKET');

  // Firebase iOS Keys
  static String get firebaseIosApiKey =>
      _getRequiredEnvVar('FIREBASE_IOS_API_KEY');

  static String get firebaseIosAppId =>
      _getRequiredEnvVar('FIREBASE_IOS_APP_ID');

  static String get firebaseIosMessagingSenderId =>
      _getRequiredEnvVar('FIREBASE_IOS_MESSAGING_SENDER_ID');

  static String get firebaseIosProjectId =>
      _getRequiredEnvVar('FIREBASE_IOS_PROJECT_ID');

  static String get firebaseIosStorageBucket =>
      _getRequiredEnvVar('FIREBASE_IOS_STORAGE_BUCKET');

  static String get firebaseIosAndroidClientId =>
      _getRequiredEnvVar('FIREBASE_IOS_ANDROID_CLIENT_ID');

  static String get firebaseIosIosClientId =>
      _getRequiredEnvVar('FIREBASE_IOS_IOS_CLIENT_ID');

  static String get firebaseIosIosBundleId =>
      _getRequiredEnvVar('FIREBASE_IOS_IOS_BUNDLE_ID');
}
