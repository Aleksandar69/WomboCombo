import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/chat/messages.dart';
import '../../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var receiverId;
  var receiverUsername;
  var recieverImage;
  var userData;
  var user;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  getCurrentUser() async {
    user = FirebaseAuth.instance.currentUser;

    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentUser();
    var args = ModalRoute.of(context)!.settings.arguments as List;
    receiverUsername = args[0];
    recieverImage = args[1];
    receiverId = args[2];
  }

  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(receiverId, user!.uid),
            ),
            NewMessage(receiverId, receiverUsername, recieverImage),
          ],
        ),
      ),
    );
  }
}
