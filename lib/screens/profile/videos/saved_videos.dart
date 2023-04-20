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
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var currentUser = FirebaseAuth.instance.currentUser;
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
        title: Text('asd'),
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
                      child: Image.network(
                        //videoDocs[index]['thumbnail'],
                        'https://image.cnbcfm.com/api/v1/image/107208951-16788775881678877586-28590333731-1080pnbcnews.jpg?v=1678882770&w=750&h=422&vtcrop=y',
                        fit: BoxFit.cover,
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
              ),
            );
          else
            return Text('No videos yet');
        },
      ),
    );
  }
}
