import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgts/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  TextEditingController controller = TextEditingController();
  static String id = 'ChatPage';
  final ScrollController _scrollController = ScrollController();
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Chat App', style: TextStyle(fontFamily: 'Pacifico')),
              centerTitle: true,
              backgroundColor: kPrimaryColor,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(message: messagesList[index])
                          : ChatBubleForFriend(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      messages.add({
                        kMessages: value,
                        kCreatedAt: DateTime.now(),
                        kId: email,
                      });
                      controller.clear();
                      _scrollController.animateTo(
                        0,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOut,
                      );
                    },
                    decoration: InputDecoration(
                      hint: Text('Send Message'),
                      suffixIcon: Icon(Icons.send, color: kPrimaryColor),
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
        } else {
          return Text("loading");
        }
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final _messageController = TextEditingController();
//   final _currentUser = FirebaseAuth.instance.currentUser!;

//   void _sendMessage() {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;

//     FirebaseFirestore.instance.collection('messages').add({
//       'text': text,
//       'sender': _currentUser.email,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Global Chat'),
//         backgroundColor: const Color(0xff2B475E),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               FirebaseAuth.instance.signOut();
//               Navigator.pushReplacementNamed(context, 'LoginPage');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final docs = snapshot.data!.docs;
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     final data = docs[index].data()! as Map<String, dynamic>;
//                     final isMe = data['sender'] == _currentUser.email;
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
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               data['sender'] ?? 'Unknown',
//                               style: const TextStyle(fontSize: 10),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(data['text'] ?? ''),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           SafeArea(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type your message...',
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     color: const Color(0xff2B475E),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
