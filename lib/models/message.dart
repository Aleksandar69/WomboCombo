import 'package:flutter/material.dart';

class Message with ChangeNotifier {
  String? id;
  String? groupChatId;
  String? messageText;
  String? senderId;
  String? senderUsername;
  String? senderImg;
  String? receiverId;
  String? receiverImg;
  String? receiverUsername;
  bool isRead;

  Message(
      this.groupChatId,
      this.messageText,
      this.senderId,
      this.senderUsername,
      this.senderImg,
      this.receiverId,
      this.receiverImg,
      this.receiverUsername,
      this.isRead);
}
