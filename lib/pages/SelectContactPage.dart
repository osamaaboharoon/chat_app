import 'package:chat_app/helper/id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class SelectContactPage extends StatelessWidget {
  final String currentUserEmail;

  const SelectContactPage({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text("Select Contact"),
        backgroundColor: Color(0xFF075E54),
      ),
      body: FutureBuilder<List<String>>(
        future: _getAllContacts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final contactEmails = snapshot.data!;

          return ListView.separated(
            itemCount: contactEmails.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.grey[300]),
            ),
            itemBuilder: (context, index) {
              final otherUserEmail = contactEmails[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF25D366), size: 28),
                ),
                title: Text(
                  otherUserEmail,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                trailing: Icon(Icons.chat, color: Colors.teal),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () async {
                  final chatId = generateChatId(
                    currentUserEmail,
                    otherUserEmail,
                  );

                  final chatData = {
                    'chatId': chatId,
                    'participant': otherUserEmail,
                    'lastMessage': '',
                    'createdAt': FieldValue.serverTimestamp(),
                  };

                  final userChatsRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserEmail)
                      .collection('chats')
                      .doc(chatId);

                  final otherUserChatsRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserEmail)
                      .collection('chats')
                      .doc(chatId);

                  final userChatDoc = await userChatsRef.get();
                  if (!userChatDoc.exists) {
                    await userChatsRef.set(chatData);
                  }

                  final otherChatDoc = await otherUserChatsRef.get();
                  if (!otherChatDoc.exists) {
                    await otherUserChatsRef.set({
                      ...chatData,
                      'participant': currentUserEmail,
                    });
                  }

                  Navigator.pushReplacement(
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
              );
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _getAllContacts() async {
    final userCollection = await FirebaseFirestore.instance
        .collection('users')
        .get();

    final chatCollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserEmail)
        .collection('chats')
        .get();

    final userEmails = userCollection.docs
        .map((doc) => doc.id)
        .where((id) => id != currentUserEmail)
        .toSet();

    final chatEmails = chatCollection.docs
        .map((doc) => doc.data()['participant'] as String)
        .where((id) => id != currentUserEmail)
        .toSet();

    final allEmails = {...userEmails, ...chatEmails}.toList();
    allEmails.sort();
    return allEmails;
  }
}
