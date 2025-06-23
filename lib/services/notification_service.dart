// ✅ ملف: notifications_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// استدعِ هذا عند تشغيل التطبيق مثلاً داخل main()
Future<void> setupFlutterNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // إنشاء قناة الإشعارات
  await createNotificationChannel();

  // ✅ استمع لتغيير التوكن (تلقائي)
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .update({'fcmToken': newToken});
    }
  });
}

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'chat_channel',
    'Chat Notifications',
    description: 'This channel is used for chat message notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

/// عرض إشعار محلي باستخدام بيانات RemoteMessage
void showFlutterNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'chat_channel',
        'Chat Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
}

/// احفظ هذا التوكن داخل Firestore عند تسجيل الدخول
Future<void> saveFCMToken(String email) async {
  final token = await FirebaseMessaging.instance.getToken();
  await FirebaseFirestore.instance.collection('users').doc(email).update({
    'fcmToken': token,
  });
}

/// احذف التوكن عند تسجيل الخروج
Future<void> deleteFCMToken(String email) async {
  await FirebaseFirestore.instance.collection('users').doc(email).update({
    'fcmToken': FieldValue.delete(),
  });
}
