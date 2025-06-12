import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chat_list_page.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/phone_login_page.dart';
import 'package:chat_app/pages/resgister_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginPage(),
        LoginPage.id: (context) => LoginPage(),
        ResgisterPage.id: (context) => ResgisterPage(),
        ChatPage.id: (context) => ChatPage(),
        ChatListPage.id: (context) => ChatListPage(),
        // PhoneLoginPage.id: (context) => PhoneLoginPage(),
      },
      initialRoute: LoginPage.id,
    );
  }
}
