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

  markMessageAsRead(groupChatId, messageId) {
    messageRepository.markMessageAsRead(groupChatId, messageId);
  }

  getMessagesForReceiver(groupChatId, receiverId) async {
    return await messageRepository.getMessagesForReceiver(
        groupChatId, receiverId);
  }

  addIsRead(groupChatId, userId) {
    messageRepository.addIsRead(groupChatId, userId);
  }

  nullifyIsRead(groupChatId) {
    messageRepository.nullifyIsRead(groupChatId);
  }

  getAllMessagesForReceiver(receiverId) async {
    return await messageRepository.getAllMessagesForReceiver(receiverId);
  }
}
