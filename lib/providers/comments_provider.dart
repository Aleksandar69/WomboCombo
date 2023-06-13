import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wombocombo/models/comment.dart';

class CommentsProvider with ChangeNotifier {
  saveComment(Comment comment) {
    return FirebaseFirestore.instance.collection('comments').doc().set({
      'comment': comment.text,
      'userId': comment.userId,
      'videoId': comment.videoId,
      'date': comment.dateTimeCommented,
      'userName': comment.userName,
      'userImage': comment.userImage,
    });
  }

  getCommentForVideo(videoId) {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('videoId', isEqualTo: videoId)
        .snapshots();
  }
}
