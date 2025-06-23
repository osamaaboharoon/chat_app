// 🔧 ChatService: مسؤول عن التفاعل مع Firestore وإرسال الإشعارات
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _db
        .collection('messages')
        .doc(chatId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required String sender,
    required String receiver,
    required String text,
  }) async {
    await _db.collection('messages').doc(chatId).collection('chat').add({
      'sender': sender,
      'receiver': receiver,
      'message': text,
      'createdAt': FieldValue.serverTimestamp(),
      'isSeen': false,
      'edited': false,
    });
  }

  Future<void> markAllAsSeen(String chatId, String currentUserEmail) async {
    final snapshot = await _db
        .collection('messages')
        .doc(chatId)
        .collection('chat')
        .where('sender', isNotEqualTo: currentUserEmail)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isSeen': true});
    }
  }

  Future<String?> getUserToken(String email) async {
    final doc = await _db.collection('users').doc(email).get();
    return doc.data()?['fcmToken'];
  }

  Future<void> sendNotification({
    required String token,
    required String sender,
    required String message,
  }) async {
    final uri = Uri.parse(
      'https://grateful-reflection-production.up.railway.app/sendNotification',
    );

    await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'toToken': token, 'title': sender, 'body': message}),
    );
  }
}
