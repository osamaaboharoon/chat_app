import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 💬 ChatBuble: فقاعة الرسالة الخاصة بالمستخدم الحالي
class ChatBuble extends StatelessWidget {
  const ChatBuble({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(message.date);
    final seenIcon = message.isSeen
        ? Icon(Icons.done_all, size: 18, color: Colors.blue)
        : Icon(Icons.check, size: 18, color: Colors.white70);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.teal.shade700,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.message, style: TextStyle(color: Colors.white)),
            if (message.edited == true)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'تم التعديل',
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
                SizedBox(width: 4),
                seenIcon,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 💬 ChatBubleForFriend: فقاعة الرسالة الخاصة بالطرف الآخر
class ChatBubleForFriend extends StatelessWidget {
  const ChatBubleForFriend({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(message.date);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.message, style: TextStyle(color: Colors.white)),
            if (message.edited == true)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'تم التعديل',
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ),
            SizedBox(height: 5),
            Text(
              formattedTime,
              style: TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
