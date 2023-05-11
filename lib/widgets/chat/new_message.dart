import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  // void _sendMessage() async {
  //   FocusScope.of(context).unfocus();
  //   final user = FirebaseAuth.instance.currentUser;
  //   final userData = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user?.uid)
  //       .get();
  //   FirebaseFirestore.instance.collection('chat').add({
  //     'text': _enteredMessage,
  //     'createdAt': Timestamp.now(),
  //     'senderId': user?.uid,
  //     'senderUsername': userData['username'],
  //     'senderImage': userData['image_url'],
  //     'receiverId': widget.receiverId,
  //     'receiverUsername': widget.receiverUsername,
  //     'receiverImg': widget.receiverImg,
  //   });
  //   _controller.clear();
  // }
  var groupChatId;
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    var currentUserId = user!.uid;
    var receiverId = widget.receiverId;
    if (user!.uid.hashCode <= widget.receiverId.hashCode) {
      groupChatId = '$currentUserId-$receiverId';
    } else {
      groupChatId = '$receiverId-$currentUserId';
    }

    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'text': _enteredMessage,
          'senderId': user?.uid,
          'senderUsername': userData['username'],
          'senderImage': userData['image_url'],
          'receiverId': widget.receiverId,
          'receiverUsername': widget.receiverUsername,
          'receiverImg': widget.receiverImg,
          'createdAt': Timestamp.now(),
        },
      );
      _enteredMessage = '';
    });
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
