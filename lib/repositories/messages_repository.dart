import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/message.dart';

class MessageRepository {
  getMessages(groupChatId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  addMessage(Message message) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(message.groupChatId)
        .collection(message.groupChatId!)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(
      {
        'text': message.messageText,
        'senderId': message.senderId,
        'senderUsername': message.senderUsername,
        'senderImage': message.senderImg,
        'receiverId': message.receiverId,
        'receiverUsername': message.receiverUsername,
        'receiverImg': message.receiverImg,
        'createdAt': Timestamp.now(),
      },
    );
  }
}
