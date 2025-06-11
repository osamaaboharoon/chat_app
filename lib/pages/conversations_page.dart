// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ConversationsPage extends StatelessWidget {
//   const ConversationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Chats")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('chats').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final chats = snapshot.data!.docs;

//           if (chats.isEmpty) {
//             return const Center(child: Text("No chats available."));
//           }

//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               final chatName = chat['chatName'];
//               final chatId = chat.id;

//               return ListTile(
//                 title: Text(chatName),
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     'ChatDetail',
//                     arguments: {'chatId': chatId, 'chatName': chatName},
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
