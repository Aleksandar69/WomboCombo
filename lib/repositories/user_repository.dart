import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/user.dart';

class UserRepository {
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

  getAllUsersWithOrderAndLimitStream(orderBy, isDescending, limit) {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy(orderBy, descending: isDescending)
        .limit(limit)
        .snapshots();
  }

  getAllUsersWithOrderAndLimit(orderBy, isDescending, limit) {
    return FirebaseFirestore.instance
        .collection("users")
        .orderBy(orderBy, descending: isDescending)
        .limit(limit);
  }

  getAllUsers(orderBy, isDescending) {
    return FirebaseFirestore.instance
        .collection("users")
        .orderBy(orderBy, descending: isDescending);
  }

  getAllUsersWithOrderAndLimitStartAfter(
      orderBy, isDescending, limit, startAfter) async {
    await FirebaseFirestore.instance
        .collection("users")
        .orderBy(orderBy, descending: isDescending)
        .limit(limit)
        .startAfterDocument(startAfter)
        .get()
        .then((value) {
      var fetchedUsers = value;
      return fetchedUsers;
    });
  }

  getAllUsersWithOrderAndLimitStartAfterStream(
      orderBy, isDescending, limit, startAfter) {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy(orderBy, descending: isDescending)
        .limit(limit)
        .startAfterDocument(startAfter)
        .snapshots();
  }

  getUserByUsername(username) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username);
  }
}
