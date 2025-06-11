// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatDetailPage extends StatefulWidget {
//   final String chatId;
//   final String chatName;

//   const ChatDetailPage({
//     super.key,
//     required this.chatId,
//     required this.chatName,
//   });

//   @override
//   State<ChatDetailPage> createState() => _ChatDetailPageState();
// }

// class _ChatDetailPageState extends State<ChatDetailPage> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   late final String uid;
//   late final String email;

//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser!;
//     uid = user.uid;
//     email = user.email!;
//   }

//   Future<void> _send() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;

//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .collection('messages')
//         .add({
//           'text': text,
//           'senderId': uid,
//           'senderEmail': email,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .update({
//           'lastMessage': text,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//     _controller.clear();
//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final messagesRef = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false);

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.chatName)),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: messagesRef.snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData)
//                   return const Center(child: CircularProgressIndicator());

//                 final docs = snapshot.data!.docs;

//                 WidgetsBinding.instance.addPostFrameCallback(
//                   (_) => _scrollToBottom(),
//                 );

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.all(8),
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     final data = docs[index].data() as Map<String, dynamic>;
//                     final isMe = data['senderId'] == uid;
//                     return Align(
//                       alignment: isMe
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blue[200] : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(data['text'] ?? ''),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(icon: const Icon(Icons.send), onPressed: _send),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
