import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListPage extends StatefulWidget {
  static String id = 'ChatListPage';

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late String currentUserEmail;

  @override
  Widget build(BuildContext context) {
    currentUserEmail = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserEmail)
                  .collection('chats')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data!.docs;

                if (chats.isEmpty) {
                  return Center(
                    child: Text(
                      'No chats yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final otherUserEmail = chat['participant'];
                    final chatId = chat['chatId'];
                    final lastMessage = chat['lastMessage'] ?? '';

                    return Center(
                      child: SizedBox(
                        width: 360,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 24,
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF25D366),
                              ),
                            ),
                            title: Text(
                              otherUserEmail,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade400,
                              ),
                              onPressed: () => _confirmDeleteChat(chatId),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatDetailPage(
                                    currentUserEmail: currentUserEmail,
                                    otherUserEmail: otherUserEmail,
                                    chatId: chatId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }

  void _confirmDeleteChat(String chatId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Chat'),
        content: Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserEmail)
                  .collection('chats')
                  .doc(chatId)
                  .delete();

              final messagesRef = FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages');

              final messages = await messagesRef.get();
              for (var doc in messages.docs) {
                await doc.reference.delete();
              }
            },
          ),
        ],
      ),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
