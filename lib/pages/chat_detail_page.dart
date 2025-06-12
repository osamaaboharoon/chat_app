import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgts/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String currentUserEmail;
  final String otherUserEmail;
  final String chatId;

  ChatDetailPage({
    required this.currentUserEmail,
    required this.otherUserEmail,
    required this.chatId,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;
    _messageController.clear();
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.chatId)
        .collection('chat')
        .add({
          'sender': widget.currentUserEmail,
          'message': messageText,
          'createdAt': FieldValue.serverTimestamp(),
        });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserEmail)
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': messageText,
          'createdAt': FieldValue.serverTimestamp(),
        });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.otherUserEmail)
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': messageText,
          'createdAt': FieldValue.serverTimestamp(),
        });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.otherUserEmail,
          style: TextStyle(fontFamily: 'Pacifico'),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
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
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index];
                    final isMe = data['sender'] == widget.currentUserEmail;

                    final messageModel = Message(
                      message: data['message'],
                      id: data['sender'],
                    );

                    return isMe
                        ? ChatBuble(message: messageModel)
                        : ChatBubleForFriend(message: messageModel);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _messageController,
              onSubmitted: (value) => sendMessage(),
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: kPrimaryColor),
                  onPressed: sendMessage,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
