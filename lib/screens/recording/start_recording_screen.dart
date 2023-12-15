import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as VT;
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/models/video.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/storage_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/providers/videos_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wombocombo/widgets/recording/video_recorder.dart';
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
  bool isLoading = false;
  var progress = 0.0;

  @override
  void dispose() {
    _videoTitleController.dispose();
    super.dispose();
  }

  var vidUrl;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    vidUrl = ModalRoute.of(context)!.settings.arguments;
    if (vidUrl != null) {
      setState(() {
        _convertedVideo = File(vidUrl!.path);
        //  _convertedVideo = File(_pickedVideo!.path);
      });
      getVideoThumbnail(_convertedVideo?.path);
    }
  }

  List<CameraDescription> _cameras = <CameraDescription>[];
  getAvailableCamerars() async {
    _cameras = await videosProvider.getAvailableCameras();
  }

  void getVideoThumbnail(videoUrl) async {
    await VT.VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: VT.ImageFormat.PNG,
    ).then((value) => videoThumbnail = File(value!));
  }

  void _recordVideo() async {
    final pickedVideoFile = await ImagePicker().pickVideo(
        source: ImageSource.camera, maxDuration: Duration(minutes: 5));

    _pickedVideo = pickedVideoFile;
    setState(() {
      _convertedVideo = File(vidUrl!.path);
      //  _convertedVideo = File(_pickedVideo!.path);
    });
    getVideoThumbnail(_convertedVideo?.path);
  }

  void confirmFileForUpload() async {
    setState(() {
      isLoading = true;
    });
    var randomNum = random.nextInt(maxNumberGenerated);
    var currentDate = DateTime.now();

    var fileName = randomNum.toString() + currentDate.toString();
    final refvid = storageProvider.addFileTwoLevels(
        'user_videos', currentUserId, fileName, 'mp4');

    final refimg = storageProvider.addFileTwoLevels(
        'user_videos', currentUserId, fileName, '.jpg');

    var videoUploadTask = refvid.putFile(File(_convertedVideo!.path));
    await refimg.putFile(File(videoThumbnail!.path));
    videoUploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        });
      }
      if (taskSnapshot.state == TaskState.success) {
        videoUrl = await refvid.getDownloadURL();
        imgUrl = await refimg.getDownloadURL();
        await videosProvider.addVideo(Video(videoUrl, currentUserId,
            Timestamp.now(), _videoTitleController.text, imgUrl));
        setState(() {
          isLoading = false;
        });
        SnackbarHelper.showSnackbarSuccess(
          context,
          'Video added',
          'Success',
        );
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getAvailableCamerars();
  }

  void getUser() async {
    currentUserId = authProvider.userId;
    user = await userProvider.getUser(currentUserId);

    username = user['username'];
  }

  final _formKey = GlobalKey<FormState>();

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
                    Navigator.of(context).pushNamed(VideoRecorder.routeName,
                        arguments: [_cameras, user["firstTimeRecordScreen"]]);

                    //_recordVideo();
                  },
                ),
              )
            : SingleChildScrollView(
                child: isLoading
                    ? Column(
                        children: [
                          CircularProgressIndicator(
                              value: progress / 100,
                              backgroundColor: Colors.amberAccent,
                              strokeWidth: 8,
                              color: Colors.green,
                              valueColor: AlwaysStoppedAnimation(Colors.red)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Please wait while your video uploads"),
                        ],
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Container(
                                  child: MyRecordedRemoteVideo(
                                      _convertedVideo, false, false, true)),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.length > 40) {
                                        return "The title mustn't exceed 40 characters";
                                      }
                                    },
                                    controller: _videoTitleController,
                                    decoration: InputDecoration(
                                      labelText: "Video title",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: Text('Save'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        confirmFileForUpload();
                                      } else {
                                        print('radivaljdaonda');
                                      }
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
