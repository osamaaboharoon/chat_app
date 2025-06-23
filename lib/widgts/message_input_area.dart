// ✏️ MessageInputArea: حقل إدخال الرسائل وزر الإرسال

import 'package:chat_app/viewmodels/chat_detail_viewmodel.dart';
import 'package:flutter/material.dart';

class MessageInputArea extends StatelessWidget {
  final ChatDetailViewModel viewModel;

  const MessageInputArea({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.insert_emoticon, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: viewModel.messageController,
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
            backgroundColor: const Color(0xFF25D366),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: viewModel.sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
