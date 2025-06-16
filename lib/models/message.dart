import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final DateTime date;
  final bool isSeen;
  final bool edited;

  Message({
    required this.message,
    required this.id,
    required this.date,
    required this.isSeen,
    required this.edited,
  });

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
      message: data['message'] ?? '',
      id: data['sender'] ?? '',
      date: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSeen: data['isSeen'] ?? false,
      edited: data['edited'] ?? false,
    );
  }
}
