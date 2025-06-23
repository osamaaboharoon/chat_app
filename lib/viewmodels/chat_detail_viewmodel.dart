// 🎯 ChatDetailViewModel: مسؤول عن إرسال الرسائل، تحديث حالة المشاهدة، وإرسال الإشعارات

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatDetailViewModel {
  final String chatId;
  final String currentUserEmail;
  final String otherUserEmail;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  ChatDetailViewModel({
    required this.chatId,
    required this.currentUserEmail,
    required this.otherUserEmail,
  });

  // ✅ إرسال رسالة
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    final messageRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'sender': currentUserEmail,
      'receiver': otherUserEmail,
      'message': text,
      'createdAt': FieldValue.serverTimestamp(),
      'isSeen': false,
      'edited': false,
    });

    // ✅ تحديث آخر رسالة لكلا المستخدمين
    final dataToUpdate = {
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSeenBy': [currentUserEmail],
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .collection('chats')
        .doc(chatId)
        .set({
          'chatId': chatId,
          'participant': otherUserEmail,
          ...dataToUpdate,
        }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserEmail)
        .collection('chats')
        .doc(chatId)
        .set({
          'chatId': chatId,
          'participant': currentUserEmail,
          ...dataToUpdate,
          'lastMessageSeenBy': [], // لم يرها بعد
        }, SetOptions(merge: true));

    // ✅ إرسال إشعار للطرف الآخر
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserEmail)
        .get();

    final fcmToken = userDoc.data()?['fcmToken'];
    if (fcmToken == null) return;

    final uri = Uri.parse(
      'https://grateful-reflection-production.up.railway.app/sendNotification',
    );

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'toToken': fcmToken,
          'title': currentUserEmail,
          'body': text,
        }),
      );

      if (response.statusCode != 200) {
        print('❌ Notification failed: ${response.body}');
      }
    } catch (e) {
      print('⚠️ Notification error: $e');
    }
  }

  // ✅ تعليم كل الرسائل كمقروءة عند فتح المحادثة
  Future<void> markMessagesAsSeen() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('sender', isNotEqualTo: currentUserEmail)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isSeen': true});
    }

    // ✅ تحديث lastMessageSeenBy
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .collection('chats')
        .doc(chatId)
        .update({
          'lastMessageSeenBy': FieldValue.arrayUnion([currentUserEmail]),
        });
  }

  // ✅ Stream للرسائل
  Stream<QuerySnapshot> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ✅ تعديل أو حذف رسالة (عند الضغط مطولًا)
  Future<void> handleLongPress(
    BuildContext context,
    dynamic message,
    DocumentSnapshot doc,
  ) async {
    if (message.id != currentUserEmail) return;

    final choice = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text('Select action:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'edit'),
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'delete'),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (choice == 'delete') {
      await doc.reference.delete();
    } else if (choice == 'edit') {
      final newText = await showDialog(
        context: context,
        builder: (_) {
          final ctrl = TextEditingController(text: message.message);
          return AlertDialog(
            title: const Text('Edit message'),
            content: TextField(controller: ctrl),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, ctrl.text),
                child: const Text('Update'),
              ),
            ],
          );
        },
      );
      if (newText != null && newText.trim().isNotEmpty) {
        await doc.reference.update({'message': newText.trim(), 'edited': true});
      }
    }
  }
}
