import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request Permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    }

    // Setup Local Notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(initSettings);

    // Setup Handler Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup Handler Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        
        // Tampilkan notifikasi lokal
        _localNotifications.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel', // id
              'High Importance Notifications', // title
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }

  // FUNGSI KHUSUS ADMIN
  // Admin akan subscribe ke topik "admin_notif"
  // Jadi setiap ada laporan baru, server cukup kirim ke topik ini, semua admin dapat.
  Future<void> subscribeToAdminTopic() async {
    await _firebaseMessaging.subscribeToTopic('admin_notif');
    debugPrint("Subscribed to admin_notif topic");
  }
  
  // Jika user logout, unsubscribe
  Future<void> unsubscribeAdminTopic() async {
    await _firebaseMessaging.unsubscribeFromTopic('admin_notif');
  }
}