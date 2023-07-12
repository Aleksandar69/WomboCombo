import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/videos_provider.dart';
import 'package:wombocombo/screens/profile/videos/saved_video.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    userId = authProvider.userId;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as List;
      userId = args[0];
    }
  }

  var userVideos;
  getVideosForUser() {
    return videosProvider.getVideoForUser(userId);
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

          if (snapshot.hasData)
            return GridView.count(
              crossAxisCount: 3, // number of columns
              children: List.generate(
                videoDocs.length, // total number of items
                (index) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    child: GestureDetector(
                      child: Container(
                          child: LayoutBuilder(builder: (ctx, constraints) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Stack(fit: StackFit.expand, children: [
                                Image.network(
                                  videoDocs[index]['thumbnail'],
                                  fit: BoxFit.cover,
                                ),
                                if (userId == videoDocs[index]['userId'])
                                  Positioned(
                                    top: constraints.maxHeight * 0.01,
                                    left: constraints.maxWidth * 0.65,
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext ctx) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Please Confirm'),
                                                  content: const Text(
                                                      'Remove user from friend list?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          videosProvider
                                                              .deleteVideo(
                                                                  videoDocs[
                                                                          index]
                                                                      .id);
                                                          setState(() {
                                                            videoDocs.removeAt(
                                                                index);
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Yes')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
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
                              ]),
                            ),
                            Container(
                              child: Text(videoDocs[index]["videoTitle"]),
                            ),
                          ],
                        );
                      })),
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
              ),
            );
          else
            return Text('No videos yet');
        },
      ),
    );
  }
}
