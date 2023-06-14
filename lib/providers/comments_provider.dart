import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wombocombo/models/comment.dart';
import '../repositories/comments_repository.dart';

class CommentsProvider with ChangeNotifier {
  CommentsRepository commentsRepository = CommentsRepository();

  saveComment(Comment comment) {
    return commentsRepository.saveComment(comment);
  }

  getCommentForVideo(videoId) {
    return commentsRepository.getCommentForVideo(videoId);
  }
}
