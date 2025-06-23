// 📄 ChatDetailPage: الصفحة الأساسية للدردشة بين مستخدمين، تحتوي على الواجهة والربط مع ViewModel
import 'package:chat_app/widgts/chat_app_bar.dart';
import 'package:chat_app/widgts/message_input_area.dart';
import 'package:chat_app/widgts/messages_list.dart';
import 'package:flutter/material.dart';
import '../viewmodels/chat_detail_viewmodel.dart';

class ChatDetailPage extends StatefulWidget {
  final String currentUserEmail, otherUserEmail, chatId;

  const ChatDetailPage({
    required this.currentUserEmail,
    required this.otherUserEmail,
    required this.chatId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late ChatDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ChatDetailViewModel(
      chatId: widget.chatId,
      currentUserEmail: widget.currentUserEmail,
      otherUserEmail: widget.otherUserEmail,
    );
    viewModel.markMessagesAsSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: ChatAppBar(otherUserEmail: widget.otherUserEmail),
      body: Column(
        children: [
          MessagesList(
            viewModel: viewModel,
            currentUserEmail: widget.currentUserEmail,
          ),
          MessageInputArea(viewModel: viewModel),
        ],
      ),
    );
  }
}
