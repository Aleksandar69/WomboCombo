import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import '../../widgets/chat/messages.dart';
import '../../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final AuthProvider authProvider = Provider.of<AuthProvider>(context);
  late final UserProvider userProvider = Provider.of<UserProvider>(context);

  var receiverId;
  var receiverUsername;
  var recieverImage;
  late final currentUserId = authProvider.userId;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  var groupChatId;
  void readLocal() {
    userProvider.updateUserInfo(currentUserId!, {'chattingWith': receiverId});
  }

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.subscribeToTopic('messages');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)!.settings.arguments as List;
    receiverUsername = args[0];
    recieverImage = args[1];
    receiverId = args[2];

    readLocal();
  }

  Future<bool> onBackPress() {
    userProvider.updateUserInfo(currentUserId!, {'chattingWith': null});
    Navigator.pop(context);
    return Future.value(false);
  }

  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          title: Text(receiverUsername),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Messages(receiverId, currentUserId!),
              ),
              NewMessage(receiverId, receiverUsername, recieverImage),
            ],
          ),
        ),
      ),
    );
  }
}
