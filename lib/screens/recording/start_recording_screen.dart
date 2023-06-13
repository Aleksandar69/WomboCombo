import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wombocombo/models/video.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/storage_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/providers/videos_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import '../../widgets/video_image_widgets/video_player.dart';
import '../../models/video.dart' as V;

class StartRecording extends StatefulWidget {
  static const routeName = '/recording';

  @override
  State<StartRecording> createState() => _StartRecordingState();
}

class _StartRecordingState extends State<StartRecording> {
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final VideosProvider videosProvider =
      Provider.of<VideosProvider>(context, listen: false);
  late final StorageProvider storageProvider =
      Provider.of<StorageProvider>(context, listen: false);
  XFile? _pickedVideo;
  File? _convertedVideo;
  var videoUrl;
  var currentUserId;
  var user;
  var maxNumberGenerated = 100000;
  Random random = Random();
  var username;
  TextEditingController _videoTitleController = TextEditingController();
  var videoThumbnail;
  var imgUrl;

  @override
  void dispose() {
    _videoTitleController.dispose();
    super.dispose();
  }

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

    var fileName = randomNum.toString() + currentDate.toString();
    final refvid = storageProvider.addFileTwoLevels(
        'user_videos', currentUserId, fileName, 'mp4');

    final refimg = storageProvider.addFileTwoLevels(
        'user_videos', currentUserId, fileName, '.jpg');

    await refvid.putFile(File(_convertedVideo!.path));
    await refimg.putFile(File(videoThumbnail!.path));

    videoUrl = await refvid.getDownloadURL();
    imgUrl = await refimg.getDownloadURL();
    await videosProvider.addVideo(Video(videoUrl, currentUserId,
        Timestamp.now(), _videoTitleController.text, imgUrl));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Success'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    currentUserId = authProvider.userId;
    user = await userProvider.getUser(currentUserId);

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
