import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/friend_status.dart';
import '../repositories/friends_repository.dart';

class FriendsProvider with ChangeNotifier {
  FriendsRepository friendsRepository = FriendsRepository();

  getFriendFilterTwoEquals(arg1, arg2, arg3, arg4) async {
    return await friendsRepository.getFriendFilterTwoEquals(
        arg1, arg2, arg3, arg4);
  }

  getFriendFilterThreeEquals(arg1, arg2, arg3, arg4, arg5, arg6) async {
    return await friendsRepository.getFriendFilterThreeEquals(
        arg1, arg2, arg3, arg4, arg5, arg6);
  }

  deleteFriend(id) {
    friendsRepository.deleteFriend(id);
  }

  updateFriend(id, arg1) {
    friendsRepository.updateFriend(id, arg1);
  }

  addFriend(FriendStatus friendStatus) {
    friendsRepository.addFriend(friendStatus);
  }
}
