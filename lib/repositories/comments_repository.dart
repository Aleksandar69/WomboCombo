import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/comment.dart';

class CommentsRepository {
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
