import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/video.dart';

class VideosRepository {
  getVideoForUser(userid) {
    return FirebaseFirestore.instance
        .collection('videos')
        .where('userId', isEqualTo: userid)
        .snapshots();
  }

  void deleteVideoForUser(String id) {
    FirebaseFirestore.instance.collection('videos').doc(id).delete();
  }

  addVideoForUser(Video video) {
    FirebaseFirestore.instance.collection('videos').doc().set({
      'videoUrl': video.videoUrl,
      'userId': video.userId,
      'createdAt': video.createdAt,
      'videoTitle': video.videoTitle,
      'thumbnail': video.thumbnailImgUrl,
    });
  }
}
