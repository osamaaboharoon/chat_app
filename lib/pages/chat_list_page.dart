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
  final TextEditingController _emailController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    currentUserEmail = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
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
                  return Center(child: Text('No chats yet'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final otherUserEmail = chat['participant'];
                    final chatId = chat['chatId'];
                    final lastMessage = chat['lastMessage'] ?? '';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade600,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          otherUserEmail,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade400),
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
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: 'Enter email to start chat',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _startChat(_emailController.text.trim()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text('Start', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startChat(String otherEmail) async {
    if (otherEmail.isEmpty || otherEmail == currentUserEmail) return;

    final chatId = _generateChatId(currentUserEmail, otherEmail);

    final chatData = {
      'chatId': chatId,
      'participant': otherEmail,
      'lastMessage': '',
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Create chat for current user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .collection('chats')
        .doc(chatId)
        .set(chatData);

    // Create chat for other user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(otherEmail)
        .collection('chats')
        .doc(chatId)
        .set({...chatData, 'participant': currentUserEmail});

    _emailController.clear();

    // Navigate to chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailPage(
          currentUserEmail: currentUserEmail,
          otherUserEmail: otherEmail,
          chatId: chatId,
        ),
      ),
    );
  }

  String _generateChatId(String email1, String email2) {
    final sortedEmails = [email1, email2]..sort();
    return sortedEmails.join('_');
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

              // لو عايز تمسح كمان الرسائل نفسها من collection messages:
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
