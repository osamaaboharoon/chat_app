import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveFCMToken(String userEmail) async {
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .update({'fcmToken': fcmToken});
      print('✅ FCM Token saved for $userEmail');
    }
  } catch (e) {
    print('❌ Error saving FCM token: $e');
  }
}
