import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListViewModel {
  late String currentUserEmail;

  Stream<QuerySnapshot> getChatsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .collection('chats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Delete Chat'),
            content: Text('Are you sure you want to delete this chat?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> deleteChat(String chatId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .collection('chats')
        .doc(chatId)
        .delete();
  }
}
