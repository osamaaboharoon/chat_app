import 'package:chat_app/widgts/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../viewmodels/chat_list_viewmodel.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  static String id = 'ChatListPage';

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late ChatListViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ChatListViewModel();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.currentUserEmail =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      body: StreamBuilder<QuerySnapshot>(
        stream: viewModel.getChatsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

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
              final lastSeenBy = chat['lastMessageSeenBy'] ?? [];
              final time = chat['lastMessageTime'] != null
                  ? (chat['lastMessageTime'] as Timestamp).toDate()
                  : null;

              final isUnread = !lastSeenBy.contains(viewModel.currentUserEmail);

              return Dismissible(
                key: ValueKey(chatId),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async =>
                    await viewModel.confirmDelete(context),
                onDismissed: (_) => viewModel.deleteChat(chatId),
                child: ChatCard(
                  otherUserEmail: otherUserEmail,
                  lastMessage: lastMessage,
                  time: time,
                  isUnread: isUnread,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDetailPage(
                        currentUserEmail: viewModel.currentUserEmail,
                        otherUserEmail: otherUserEmail,
                        chatId: chatId,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
