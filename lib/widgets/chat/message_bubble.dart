import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String userImage;
  MessageBubble(this.message, this.isMe, this.userName, this.userImage,
      {required this.key});
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: isMe
                      ? themeProvider.darkTheme
                          ? Color.fromARGB(255, 3, 81, 182)
                          : Color.fromARGB(255, 178, 230, 231)
                      : themeProvider.darkTheme
                          ? Color.fromARGB(255, 53, 80, 141)
                          : Color.fromARGB(255, 203, 229, 230),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
          top: 0,
          left: isMe ? null : 130,
          right: isMe ? 120 : null,
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
