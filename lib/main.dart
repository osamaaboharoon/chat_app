import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/WhatsAppHomePage.dart';
import 'package:chat_app/pages/chat_list_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/privacy_policy_page.dart';
import 'package:chat_app/pages/resgister_page.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:chat_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  showFlutterNotification(message); // تظهر الإشعار حتى لو التطبيق بالخلفية
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await setupFlutterNotifications();

  // طلب صلاحية الإشعارات (مرّة واحدة فقط)
  await FirebaseMessaging.instance.requestPermission();

  // استقبال الرسائل أثناء فتح التطبيق
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showFlutterNotification(message);
    }
  });

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
        '/': (context) => LoginPage(),
        SettingsPage.id: (context) => SettingsPage(currentUserEmail: ''),
        PrivacyPolicyPage.id: (context) => const PrivacyPolicyPage(),

        LoginPage.id: (context) => LoginPage(),
        ResgisterPage.id: (context) => ResgisterPage(),
        // ChatPage.id: (context) => ChatPage(),
        ChatListPage.id: (context) => ChatListPage(),
        WhatsAppHomePage.id: (context) => WhatsAppHomePage(),
        // PhoneLoginPage.id: (context) => PhoneLoginPage(),
      },
      initialRoute: LoginPage.id,
    );
  }
}
