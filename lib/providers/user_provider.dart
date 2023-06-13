import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/user.dart';

class UserProvider with ChangeNotifier {
  updateUserInfo(String userId, updateData) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(updateData);
  }

  getUser(userId) async {
    var fetchedUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      fetchedUser = value;
    });
    return fetchedUser;
  }

  addUser(User user, imgUrl) {
    return FirebaseFirestore.instance.collection('users').doc(user.id).set({
      'username': user.username,
      'email': user.email,
      'image_url': imgUrl,
      'userPoints': 0,
      'chattingWith': null,
      'currentMaxLevel': 1,
    });
  }

  getUserFilterIsEqualTo(arg1, arg2) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(arg1, isEqualTo: arg2)
        .snapshots();
  }

  getAllUsersWithOrderAndLimit(orderBy, isDescending, limit) {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy(orderBy, descending: isDescending)
        .limit(50)
        .snapshots();
  }
}
