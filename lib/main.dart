import 'package:flutter/material.dart';

void main() {
  runApp(const Chatty());
}

class Chatty extends StatelessWidget {
  const Chatty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold());
  }
}
