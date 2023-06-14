import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wombocombo/models/message.dart';
import '../repositories/messages_repository.dart';

class MessagesProvider with ChangeNotifier {
  MessageRepository messageRepository = MessageRepository();

  getMessages(groupChatId) {
    return messageRepository.getMessages(groupChatId);
  }

  addMessage(Message message) {
    messageRepository.addMessage(message);
  }
}
