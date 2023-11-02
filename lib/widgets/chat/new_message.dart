import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/message.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/messages_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';

class NewMessage extends StatefulWidget {
  static const routeName = '/new-message';
  var receiverId;
  var receiverUsername;
  var receiverImg;

  NewMessage(this.receiverId, this.receiverUsername, this.receiverImg);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  late final MessagesProvider messagesProvider =
      Provider.of<MessagesProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  var _enteredMessage = '';
  final _controller = new TextEditingController();
  var groupChatId;
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final currentUserId = authProvider.userId;
    final userData = await userProvider.getUser(currentUserId);
    var receiverId = widget.receiverId;
    if (currentUserId.hashCode <= widget.receiverId.hashCode) {
      groupChatId = '$currentUserId-$receiverId';
    } else {
      groupChatId = '$receiverId-$currentUserId';
    }
    messagesProvider.addMessage(Message(
      groupChatId,
      _enteredMessage,
      currentUserId,
      userData['username'],
      userData['image_url'],
      widget.receiverId,
      widget.receiverImg,
      widget.receiverUsername,
      false,
    ));
    messagesProvider.addIsRead(groupChatId, receiverId);
    _enteredMessage = '';
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty || _enteredMessage == ''
                ? null
                : () {
                    _enteredMessage.trim().isEmpty || _enteredMessage == ''
                        ? null
                        : _sendMessage();
                  },
            icon: Icon(Icons.send),
            color: _enteredMessage.trim().isEmpty || _enteredMessage == ''
                ? Colors.grey
                : Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
