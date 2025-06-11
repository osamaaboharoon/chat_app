import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatId;
  final String chatName;

  const ChatDetailPage({super.key, required this.chatId, required this.chatName});

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final email = FirebaseAuth.instance.currentUser!.email!;
    final messagesRef = FirebaseFirestore.instance
        .collection('conversations/$chatId/messages')
        .orderBy('timestamp', descending: false);

    Future<void> _send() async {
      final text = _controller.text.trim();
      if (text.isEmpty) return;
      await FirebaseFirestore.instance
          .collection('conversations/$chatId/messages')
          .add({
        'text': text,
        'senderId': uid,
        'senderEmail': email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(chatId)
          .update({
        'lastMessage': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _controller.clear();
    }

    return Scaffold(
      appBar: AppBar(title: Text(chatName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.snapshots(),
              builder: (c, s) {
                if (!s.hasData) return const Center(child: CircularProgressIndicator());
                final docs = s.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(data['text'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _controller),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
