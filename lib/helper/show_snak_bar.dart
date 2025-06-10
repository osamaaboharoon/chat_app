import 'package:flutter/material.dart';

void showSnakBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
