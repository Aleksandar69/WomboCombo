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

  getMessagesForReceiver(groupChatId, receiverId) async {
    var fetchedMessages;
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .where('isRead', isEqualTo: false)
        .where('receiverId', isEqualTo: receiverId)
        .get()
        .then((value) {
      fetchedMessages = value;
    });
    return fetchedMessages;
  }

  getAllMessagesForReceiver(receiverId) async {
    var fetchedMessages;
    await FirebaseFirestore.instance
        .collection('messages')
        .where('unreadMessages', isEqualTo: receiverId)
        .get()
        .then((value) {
      fetchedMessages = value;
    });
    return fetchedMessages;
  }

  markMessageAsRead(groupChatId, messageId) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId!)
        .doc(messageId)
        .update(
      {'isRead': true},
    );
  }

  addIsRead(groupChatId, userId) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .set({'unreadMessages': userId});
  }

  nullifyIsRead(groupChatId) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .set({'unreadMessages': null});
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
        'isRead': false,
      },
    );
  }
}
