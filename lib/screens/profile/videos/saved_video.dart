import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../widgets/video_image_widgets/video_player.dart';
import 'package:intl/intl.dart';

class SavedVideo extends StatefulWidget {
  static const routeName = '/saved-video';

  @override
  State<SavedVideo> createState() => _SavedVideoState();
}

class _SavedVideoState extends State<SavedVideo> {
  var videoUrl;
  TextEditingController commentController = TextEditingController();
  var currentUser;
  var videoId;
  var username;
  var userImage;
  var user;

  void getUser() async {
    currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get(GetOptions(source: Source.server))
        .then((value) {
      user = value;
    });

    username = user['username'];
    userImage = user['image_url'];
  }

  void saveComment() {
    FirebaseFirestore.instance.collection('comments').doc().set({
      'comment': commentController.text,
      'userId': currentUser.uid,
      'videoId': videoId,
      'date': Timestamp.now(),
      'userName': username,
      'userImage': userImage,
    });

    commentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Success'),
        backgroundColor: Theme.of(context).errorColor,
      ),
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
                child: MyRecordedRemoteVideo(videoUrl, true),
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
                    onPressed: () => saveComment(),
                    icon: Icon(Icons.forward),
                    label: Text(''),
                  )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .where('videoId', isEqualTo: videoId)
                  .snapshots(),
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
                                  color: Colors.black,
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
