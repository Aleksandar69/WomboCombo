import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/messages_provider.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  final String receiverId;
  final String currentUserId;
  Messages(this.receiverId, this.currentUserId);

  @override
  Widget build(BuildContext context) {
    final MessagesProvider messagesProvider =
        Provider.of<MessagesProvider>(context, listen: false);
    var groupChatId;
    if (currentUserId.hashCode <= receiverId.hashCode) {
      groupChatId = '$currentUserId-$receiverId';
    } else {
      groupChatId = '$receiverId-$currentUserId';
    }
    return StreamBuilder(
      stream: messagesProvider.getMessages(groupChatId),
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
            if (chatDocs?[index]['senderId'] == currentUserId)
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
          },
        );
      },
    );
  }
}
