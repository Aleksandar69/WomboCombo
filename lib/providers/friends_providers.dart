import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/friend_status.dart';
import '../repositories/friendsRepository.dart';

class FriendsProvider with ChangeNotifier {
  FriendsRepository friendsRepository = FriendsRepository();

  getFriendFilterIsEqualTo(
    arg1,
    arg2,
  ) async {
    return await friendsRepository.getFriendFilterIsEqualTo(arg1, arg2);
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
