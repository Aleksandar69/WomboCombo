import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/models/comment.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/comments_provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import '../../../widgets/video_image_widgets/video_player.dart';
import 'package:intl/intl.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SavedVideo extends StatefulWidget {
  static const routeName = '/saved-video';

  @override
  State<SavedVideo> createState() => _SavedVideoState();
}

class _SavedVideoState extends State<SavedVideo> {
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final CommentsProvider commentsProvider =
      Provider.of<CommentsProvider>(context, listen: false);
  var videoUrl;
  TextEditingController commentController = TextEditingController();
  var currentUserId;
  var videoId;
  var username;
  var userImage;
  var user;

  void getUser() async {
    currentUserId = authProvider.userId;

    user = await userProvider.getUser(currentUserId);

    username = user['username'];
    userImage = user['image_url'];
  }

  void submitComment() {
    commentsProvider.saveComment(Comment(
      commentController.text,
      currentUserId,
      username,
      userImage,
      videoId,
      Timestamp.now(),
    ));
    commentController.clear();

    SnackbarHelper.showSnackbarSuccess(
      context,
      'Comment added',
      'Success',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final countdownTimerStuff =
        ModalRoute.of(context)!.settings.arguments as List;
    videoUrl = countdownTimerStuff[0];
    videoId = countdownTimerStuff[1];
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Video'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 640,
                width: 360,
                child: MyRecordedRemoteVideo(videoUrl, true, false, true, null),
              ),
            ),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    child: TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment',
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => submitComment(),
                    icon: Icon(Icons.forward),
                    label: Text(''),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: commentsProvider.getCommentForVideo(videoId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final commentDocs = snapshot.data!.docs as List;

                commentDocs.sort((a, b) {
                  return a['date'].compareTo(b['date']);
                });

                return Container(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: commentDocs?.length,
                      itemBuilder: (context, index) {
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            commentDocs![index]['date'].millisecondsSinceEpoch);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(commentDocs![index]['userImage']),
                          ),
                          title: Text(
                            '@' + commentDocs![index]['userName'].toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentDocs![index]['comment'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat.yMd().add_jm().format(date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
