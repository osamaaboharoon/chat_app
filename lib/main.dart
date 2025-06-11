import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chat_detail_page.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/conversations_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/resgister_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      debugShowCheckedModeBanner: false,
      routes: {
        'LoginPage': (context) => LoginPage(),
        'ResgisterPage': (context) => ResgisterPage(),
        'ChatPage': (context) => ChatPage(),
        'ConversationsPage': (context) => ConversationsPage(),
        'ChatDetail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return ChatDetailPage(
            chatId: args['chatId'],
            chatName: args['chatName'],
          );
        },
      },
      home: FirebaseAuth.instance.currentUser == null
          ? LoginPage()
          : ConversationsPage(),
    );
  }
}
