import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Video with ChangeNotifier {
  String? videoUrl;
  String? userId;
  Timestamp? createdAt;
  String? videoTitle;
  String? thumbnailImgUrl;

  Video(
    this.videoUrl,
    this.userId,
    this.createdAt,
    this.videoTitle,
    this.thumbnailImgUrl,
  );
}
