import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/video.dart';
import '../repositories/videos_repository.dart';
import 'package:camera/camera.dart';

class VideosProvider with ChangeNotifier {
  VideosRepository videosRepository = VideosRepository();

  getVideoForUser(userid) {
    return videosRepository.getVideoForUser(userid);
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

  getAvailableCameras() async {
    var availableCams = await availableCameras();
    return availableCams;
  }
}
