import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

// Handler untuk notifikasi saat aplikasi ditutup/background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Inisialisasi Service
  Future<void> init() async {
    // 1. Request Permission (Penting untuk Android 13+ dan iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    }

    // 2. Setup Local Notifications (Agar notif muncul pop-up saat aplikasi sedang dibuka)
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(initSettings);

    // 3. Setup Handler Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 4. Setup Handler Foreground (Aplikasi sedang aktif)
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

  // --- FUNGSI KHUSUS ADMIN ---
  // Admin akan subscribe ke topik "admin_notif"
  // Jadi setiap ada laporan baru, server cukup kirim ke topik ini, semua admin dapat.
  Future<void> subscribeToAdminTopic() async {
    await _firebaseMessaging.subscribeToTopic('admin_notif');
    debugPrint("Subscribed to admin_notif topic");
  }
  
  // Jika user logout, unsubscribe (opsional)
  Future<void> unsubscribeAdminTopic() async {
    await _firebaseMessaging.unsubscribeFromTopic('admin_notif');
  }
}