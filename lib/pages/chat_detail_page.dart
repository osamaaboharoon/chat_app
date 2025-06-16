import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgts/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatDetailPage extends StatefulWidget {
  final String currentUserEmail, otherUserEmail, chatId;

  ChatDetailPage({
    required this.currentUserEmail,
    required this.otherUserEmail,
    required this.chatId,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _markAllSeen();
  }

  Future<void> _markAllSeen() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chatId)
        .collection('chat')
        .where('sender', isNotEqualTo: widget.currentUserEmail)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isSeen': true});
    }
  }

  void sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chatId)
        .collection('chat')
        .add({
          'sender': widget.currentUserEmail,
          'receiver': widget.otherUserEmail,
          'message': text,
          'createdAt': FieldValue.serverTimestamp(),
          'isSeen': false,
          'edited': false,
        });

    _scroll.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.otherUserEmail)
              .snapshots(),
          builder: (ctx, snap) {
            String status = '';
            if (snap.hasData) {
              final data = snap.data!.data() as Map<String, dynamic>?;
              if (data != null && data['lastSeen'] != null) {
                final seen = (data['lastSeen'] as Timestamp).toDate();
                final diff = DateTime.now().difference(seen);
                if (diff.inMinutes < 5)
                  status = 'online';
                else
                  status = 'Last seen ${DateFormat('h:mm a').format(seen)}';
              }
            }
            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF25D366)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.otherUserEmail,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        status,
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(widget.chatId)
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, snap) {
                if (!snap.hasData)
                  return Center(child: CircularProgressIndicator());

                final docs = snap.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scroll.hasClients) {
                    _scroll.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  reverse: true,
                  controller: _scroll,
                  itemCount: docs.length,
                  itemBuilder: (ctx, idx) {
                    final originalDoc = docs[idx];
                    final rawData = originalDoc.data() as Map<String, dynamic>;
                    final fixedData = {
                      ...rawData,
                      'receiver':
                          rawData['receiver'] ?? widget.currentUserEmail,
                    };
                    final messageModel = Message.fromJson(fixedData);

                    return GestureDetector(
                      onLongPress: () async {
                        if (messageModel.id != widget.currentUserEmail) return;

                        final choice = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Text('Select action:'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'edit'),
                                child: Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'delete'),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (choice == 'delete') {
                          await originalDoc.reference.delete();
                        } else if (choice == 'edit') {
                          final newText = await showDialog(
                            context: context,
                            builder: (_) {
                              final ctrl = TextEditingController(
                                text: messageModel.message,
                              );
                              return AlertDialog(
                                title: Text('Edit message'),
                                content: TextField(controller: ctrl),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, ctrl.text),
                                    child: Text('Update'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (newText != null && newText.trim().isNotEmpty) {
                            await originalDoc.reference.update({
                              'message': newText.trim(),
                              'edited': true,
                            });
                          }
                        }
                      },
                      child: messageModel.id == widget.currentUserEmail
                          ? ChatBuble(message: messageModel)
                          : ChatBubleForFriend(message: messageModel),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.insert_emoticon, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
