import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveFCMToken(String userEmail) async {
  try {
    print('📢 Trying to save token for $userEmail');
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('🎯 FCM Token = $fcmToken');

    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(userEmail).set({
        'fcmToken': fcmToken,
      }, SetOptions(merge: true));
      print('✅ FCM Token saved for $userEmail');
    } else {
      print('⚠️ FCM Token is null');
    }
  } catch (e) {
    print('❌ Error saving FCM token: $e');
  }
}
