import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment with ChangeNotifier {
  String? id;
  String? text;
  String? userId;
  String? userName;
  String? userImage;
  String? videoId;
  Timestamp dateTimeCommented;
  Comment(this.text, this.userId, this.userName, this.userImage, this.videoId,
      this.dateTimeCommented);
}
