import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wombocombo/screens/profile/videos/saved_video.dart';

class SavedVideos extends StatefulWidget {
  static const routeName = '/saved-vids';

  @override
  State<SavedVideos> createState() => _SavedVideosState();
}

class _SavedVideosState extends State<SavedVideos> {
  bool isLoading = false;
  var userId;
  var currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser!.uid;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as List;
      userId = args[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Videos'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('userId', isEqualTo: userId)
            .snapshots(),
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
                        return Stack(fit: StackFit.expand, children: [
                          Image.network(
                            videoDocs[index]['thumbnail'],
                            fit: BoxFit.cover,
                          ),
                          if (currentUser.uid == videoDocs[index]['userId'])
                            Positioned(
                              top: constraints.maxHeight * 0.65,
                              left: constraints.maxWidth * 0.65,
                              child: IconButton(
                                  onPressed: () {
                                    _deleteVideo(videoDocs[index].id);
                                    setState(() {
                                      videoDocs.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade700,
                                  )),
                            ),
                        ]);
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

  void _deleteVideo(String id) {
    FirebaseFirestore.instance.collection('videos').doc(id).delete();
  }
}
