import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wombocombo/widgets/main_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';
import '../../widgets/video_image_widgets/video_player.dart';

class StartRecording extends StatefulWidget {
  static const routeName = '/recording';

  @override
  State<StartRecording> createState() => _StartRecordingState();
}

class _StartRecordingState extends State<StartRecording> {
  // const StartRecording({Key? key}) : super(key: key);
  XFile? _pickedVideo;
  File? _convertedVideo;
  var videoUrl;
  var currentUser;
  var user;
  var maxNumberGenerated = 100000;
  Random random = Random();
  var username;
  TextEditingController _videoTitleController = TextEditingController();
  var videoThumbnail;
  var imgUrl;

  void getVideoThumbnail(videoUrl) async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    ).then((value) => videoThumbnail = File(value!));
  }

  void _pickVideo() async {
    final pickedVideoFile =
        await ImagePicker().pickVideo(source: ImageSource.camera);

    _pickedVideo = pickedVideoFile;
    setState(() {
      _convertedVideo = File(_pickedVideo!.path);
    });
    getVideoThumbnail(_convertedVideo?.path);
  }

  void confirmFileForUpload() async {
    var randomNum = random.nextInt(maxNumberGenerated);
    var currentDate = DateTime.now();

    final refvid = FirebaseStorage.instance
        .ref()
        .child('user_videos')
        .child(currentUser!.uid)
        .child(randomNum.toString() + currentDate.toString() + '.mp4');

    final refimg = FirebaseStorage.instance
        .ref()
        .child('user_videos')
        .child(currentUser!.uid)
        .child(randomNum.toString() + currentDate.toString() + '.jpg');

    await refvid.putFile(File(_convertedVideo!.path));
    await refimg.putFile(File(videoThumbnail!.path));

    videoUrl = await refvid.getDownloadURL();
    imgUrl = await refimg.getDownloadURL();

    FirebaseFirestore.instance.collection('videos').doc().set({
      'videoUrl': videoUrl,
      'userId': currentUser!.uid,
      'createdAt': Timestamp.now(),
      'videoTitle': _videoTitleController.text,
      'thumbnail': imgUrl,
    });
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Session Recording"),
      ),
      body: Center(
        child: _convertedVideo == null
            ? Container(
                height: 200,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 200),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.red.shade900),
                  child: Text(
                    'Start Recording',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _pickVideo();
                  },
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Container(
                            height: 640,
                            width: 360,
                            child:
                                MyRecordedRemoteVideo(_convertedVideo, false)),
                      ),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _videoTitleController,
                              decoration: InputDecoration(
                                labelText: "Video title",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            ElevatedButton(
                              child: Text('Save'),
                              onPressed: () {
                                confirmFileForUpload();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Success'),
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
