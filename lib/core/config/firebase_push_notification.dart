import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:verbisense/core/config/app_logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.i('Handling a background message: ${message.messageId}');
}

//TODO: integrate the IOS
class FirebasePushNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<String?> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    _initPushNotifications();

    final fcmToken = await _firebaseMessaging.getToken();
    AppLogger.i('FCM Token: $fcmToken');
    return fcmToken;
  }

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future<void> _initLocalNotifications() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // TODO:Add ios
    final settings = InitializationSettings(android: android);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        // Handle notification tap
        AppLogger.i('Notification tapped with payload: $payload');
      },
    );
  }

  Future<void> _initPushNotifications() async {
    await _initLocalNotifications();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;

      if (notification == null) return;

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      final notificationDetails = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
      );
    });
  }
}
