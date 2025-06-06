import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/resgister_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'LoginPage': (context) => LoginPage(),
        'ResgisterPage': (context) => ResgisterPage(),
      },
      initialRoute: 'LoginPage',
    );
  }
}
