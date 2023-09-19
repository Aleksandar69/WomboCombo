import 'package:flutter/material.dart';
import 'package:wombocombo/models/video.dart';
import 'package:wombocombo/providers/videos_provider.dart';

class VideoListItem extends StatelessWidget {
  final Video video;
  final String userId;
  final VideosProvider videosProvider;
  final String videoId;
  final int index;

  VideoListItem(
      {required this.video,
      required this.userId,
      required this.videosProvider,
      required this.videoId,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9, // Set the aspect ratio as needed
          child: Image.network(
            video.thumbnailImgUrl!,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          video.videoTitle!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
