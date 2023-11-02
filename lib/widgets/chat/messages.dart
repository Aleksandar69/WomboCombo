import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/messages_provider.dart';
import './message_bubble.dart';

class Messages extends StatefulWidget {
  final String receiverId;
  final String currentUserId;
  Messages(this.receiverId, this.currentUserId);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late final MessagesProvider messagesProvider =
      Provider.of<MessagesProvider>(context, listen: false);
  var groupChatId;
  var messages;
  var isLoading = true;

  getUnreadMess() async {
    messages = await messagesProvider.getMessagesForReceiver(
        groupChatId, widget.currentUserId);

    for (var message in messages.docs) {
      messagesProvider.markMessageAsRead(groupChatId, message.id);
    }
    messagesProvider.nullifyIsRead(groupChatId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (widget.currentUserId.hashCode <= widget.receiverId.hashCode) {
      groupChatId = '${widget.currentUserId}-${widget.receiverId}';
    } else {
      groupChatId = '${widget.receiverId}-${widget.currentUserId}';
    }
    await getUnreadMess();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder(
            stream: messagesProvider.getMessages(groupChatId),
            builder: (context, AsyncSnapshot snapshot) {
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
                  if (chatDocs?[index]['senderId'] == widget.currentUserId)
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
