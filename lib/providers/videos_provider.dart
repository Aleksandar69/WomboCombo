import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/video.dart';
import '../repositories/videos_repository.dart';

class VideosProvider with ChangeNotifier {
  VideosRepository videosRepository = VideosRepository();

  getVideoForUser(userid) {
    return FirebaseFirestore.instance
        .collection('videos')
        .where('userId', isEqualTo: userid)
        .snapshots();
  }

  getVideo(userId) {
    videosRepository.getVideoForUser(userId);
  }

  void deleteVideo(String id) {
    videosRepository.deleteVideoForUser(id);
  }

  addVideo(Video video) {
    videosRepository.addVideoForUser(video);
  }
}
