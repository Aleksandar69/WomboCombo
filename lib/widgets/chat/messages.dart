import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  final String receiverId;
  final String currentUserId;
  Messages(this.receiverId, this.currentUserId);

  @override
  Widget build(BuildContext context) {
    var groupChatId;
    if (currentUserId.hashCode <= receiverId.hashCode) {
      groupChatId = '$currentUserId-$receiverId';
    } else {
      groupChatId = '$receiverId-$currentUserId';
    }

    Firebase.initializeApp();
    var currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .limit(20)
          .orderBy('createdAt', descending: true)
          .snapshots(),

      // FirebaseFirestore.instance
      //     .collection('chat')
      //     .where('receiverId', isEqualTo: receiverId)
      //     .orderBy('createdAt', descending: true)
      //     .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        print('state: ${snapshot.connectionState} ');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs as List;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length,
          itemBuilder: (context, index) {
            if (chatDocs?[index]['senderId'] == currentUser?.uid)
              return MessageBubble(
                chatDocs?[index]['text'],
                true,
                chatDocs?[index]['senderUsername'],
                chatDocs?[index]['senderImage'],
                key: ValueKey(chatDocs?[index].id),
              );
            else
              return MessageBubble(
                chatDocs?[index]['text'],
                false,
                chatDocs?[index]['senderUsername'],
                chatDocs?[index]['senderImage'],
                key: ValueKey(chatDocs?[index].id),
              );
            //return chatDocs?[index]['text'] != null ? Text(chatDocs?[index]['text']) : Text('');
          },
        );
      },
    );
  }
}
