// import 'package:chat_app/helper/constants.dart';
// import 'package:chat_app/models/message.dart';
// import 'package:chat_app/widgts/chat_buble.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatPage extends StatelessWidget {
//   ChatPage({super.key});
//   TextEditingController controller = TextEditingController();
//   static String id = 'ChatPage';
//   final ScrollController _scrollController = ScrollController();
//   CollectionReference messages = FirebaseFirestore.instance.collection(
//     kMessagesCollection,
//   );
//   Widget build(BuildContext context) {
//     final String email = ModalRoute.of(context)!.settings.arguments as String;
//     return StreamBuilder<QuerySnapshot>(
//       stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Message> messagesList = [];
//           for (int i = 0; i < snapshot.data!.docs.length; i++) {
//             messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
//           }

//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Chat App', style: TextStyle(fontFamily: 'Pacifico')),
//               centerTitle: true,
//               backgroundColor: kPrimaryColor,
//             ),
//             body: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     reverse: true,
//                     controller: _scrollController,
//                     itemCount: messagesList.length,
//                     itemBuilder: (context, index) {
//                       return messagesList[index].id == email
//                           ? ChatBuble(message: messagesList[index])
//                           : ChatBubleForFriend(message: messagesList[index]);
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: TextField(
//                     controller: controller,
//                     onSubmitted: (value) {
//                       messages.add({
//                         kMessages: value,
//                         kCreatedAt: DateTime.now(),
//                         kId: email,
//                       });
//                       controller.clear();
//                       _scrollController.animateTo(
//                         0,
//                         duration: Duration(seconds: 1),
//                         curve: Curves.easeOut,
//                       );
//                     },
//                     decoration: InputDecoration(
//                       hint: Text('Send Message'),
//                       suffixIcon: Icon(Icons.send, color: kPrimaryColor),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(color: kPrimaryColor),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                         borderSide: BorderSide(color: kPrimaryColor),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Text("loading");
//         }
//       },
//     );
//   }
// }
