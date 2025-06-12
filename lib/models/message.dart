import 'package:chat_app/helper/constants.dart';

class Message {
  final String message;
  final String id;
  final String data;

  Message(this.message, this.id, this.data);

  factory Message.fromJson(jsonData) {
    return Message(
      jsonData[kMessages],
      jsonData[kId],
      jsonData[kCreatedAt].toString(),
    );
  }
}
