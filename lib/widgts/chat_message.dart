import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text, senderId, senderEmail;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.senderId,
    required this.senderEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'senderId': senderId,
    'senderEmail': senderEmail,
    'timestamp': timestamp.toUtc(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'] as String,
    senderId: json['senderId'] as String,
    senderEmail: json['senderEmail'] as String,
    timestamp: (json['timestamp'] as Timestamp).toDate(),
  );
}
