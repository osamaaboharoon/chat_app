import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data = chats[index].data() as Map<String, dynamic>;
              final chatId = chats[index].id;
              return ListTile(
                title: Text(data['name'] ?? 'Unnamed'),
                subtitle: Text(data['lastMessage'] ?? ''),
                onTap: () {
                  Navigator.pushNamed(context, 'ChatDetail', arguments: {
                    'chatId': chatId,
                    'chatName': data['name'],
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
