// 💬 MessagesList: يعرض قائمة الرسائل بين المستخدمين باستخدام StreamBuilder
import 'package:chat_app/models/message.dart';
import 'package:chat_app/viewmodels/chat_detail_viewmodel.dart';
import 'package:chat_app/widgts/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatelessWidget {
  final ChatDetailViewModel viewModel;
  final String currentUserEmail;

  const MessagesList({required this.viewModel, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: viewModel.getMessagesStream(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.scrollController.hasClients) {
              viewModel.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return ListView.builder(
            reverse: true,
            controller: viewModel.scrollController,
            itemCount: docs.length,
            itemBuilder: (ctx, idx) {
              final originalDoc = docs[idx];
              final rawData = originalDoc.data() as Map<String, dynamic>;
              final fixedData = {
                ...rawData,
                'receiver': rawData['receiver'] ?? currentUserEmail,
              };
              final messageModel = Message.fromJson(fixedData);

              return GestureDetector(
                onLongPress: () => viewModel.handleLongPress(
                  context,
                  messageModel,
                  originalDoc,
                ),
                child: messageModel.id == currentUserEmail
                    ? ChatBuble(message: messageModel)
                    : ChatBubleForFriend(message: messageModel),
              );
            },
          );
        },
      ),
    );
  }
}
