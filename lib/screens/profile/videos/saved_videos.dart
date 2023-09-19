import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wombocombo/models/video.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/videos_provider.dart';
import 'package:wombocombo/screens/profile/videos/saved_video.dart';
import 'package:wombocombo/widgets/profile/videos/video_list_item.dart';

class SavedVideos extends StatefulWidget {
  static const routeName = '/saved-vids';

  @override
  State<SavedVideos> createState() => _SavedVideosState();
}

class _SavedVideosState extends State<SavedVideos> {
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final VideosProvider videosProvider =
      Provider.of<VideosProvider>(context, listen: false);
  bool isLoading = false;
  var userId;
  var currentUserId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currentUserId = authProvider.userId;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as List;
      userId = args[0];
    }
  }

  var userVideos;
  getVideosForUser() {
    return userId != null || userId != ''
        ? videosProvider.getVideoForUser(userId)
        : videosProvider.getVideoForUser(currentUserId);
  }

  removeVideo(String id, int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Videos'),
      ),
      body: StreamBuilder(
        stream: getVideosForUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final videoDocs = snapshot.data!.docs as List;

          videoDocs.sort((a, b) {
            return a['createdAt'].compareTo(b['createdAt']);
          });

          if (snapshot.data.size > 0)
            return ListView.builder(
              itemCount: videoDocs.length,
              itemBuilder: (context, index) {
                var currentVideo = videoDocs[index];
                Video video = Video(
                    currentVideo['videoUrl'],
                    currentVideo['userId'],
                    currentVideo['createdAt'],
                    currentVideo['videoTitle'],
                    currentVideo['thumbnail']);
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Stack(
                        children: [
                          VideoListItem(
                              video: video,
                              userId: userId,
                              videosProvider: videosProvider,
                              videoId: currentVideo.id,
                              index: index),
                          if (currentUserId == video.userId)
                            Align(
                              heightFactor: 4.2,
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Please Confirm',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            content: const Text(
                                                'Remove your video?',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    videosProvider.deleteVideo(
                                                        videoDocs[index].id);
                                                    setState(() {
                                                      videoDocs.removeAt(index);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('No'))
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade700,
                                  )),
                            ),
                          Align(
                            heightFactor: 2.5,
                            alignment: Alignment.bottomCenter,
                            child: Icon(
                              Icons.play_arrow,
                              size: 50,
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(SavedVideo.routeName, arguments: [
                        videoDocs[index]['videoUrl'],
                        videoDocs[index].id,
                      ]);
                    },
                  ),
                );
              },
            );
          else
            return Center(
              child: Text(
                'No videos posted',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            );
        },
      ),
    );
  }
}
