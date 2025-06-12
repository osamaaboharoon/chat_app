import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;

  Message({required this.message, required this.id});

  factory Message.fromJson(DocumentSnapshot doc) {
    return Message(message: doc['message'], id: doc['sender']);
  }
}
