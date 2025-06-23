// 📌 ChatAppBar: يعرض اسم المستخدم الآخر وحالة الظهور (أونلاين أو آخر ظهور)
import 'package:chat_app/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String otherUserEmail;

  const ChatAppBar({required this.otherUserEmail});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserEmail)
            .snapshots(),
        builder: (ctx, snap) {
          String status = '';
          if (snap.hasData) {
            final data = snap.data!.data() as Map<String, dynamic>?;
            if (data != null && data['lastSeen'] != null) {
              final seen = (data['lastSeen'] as Timestamp).toDate();
              final diff = DateTime.now().difference(seen);
              status = diff.inMinutes < 5
                  ? 'online'
                  : 'Last seen ${DateFormat('h:mm a').format(seen)}';
            }
          }
          return Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF25D366)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUserEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
