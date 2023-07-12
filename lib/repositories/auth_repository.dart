import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as U;

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  loginUser(U.User user) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      return authResult;
    } catch (e) {
      throw e;
    }
  }

  changePassowrd(newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      throw e;
    }
  }

  changeEmail(newEmail) async {
    try {
      await _auth.currentUser!.updateEmail(newEmail);
    } catch (e) {
      throw e;
    }
  }

  registerUser(U.User user) async {
    UserCredential authResult = await _auth.createUserWithEmailAndPassword(
      email: user.email!,
      password: user.password!,
    );

    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(authResult.user!.uid + '.jpg');

    await ref.putFile(File(user.profileImage!.path));

    final url = await ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user!.uid)
        .set({
      'username': user.username,
      'email': user.email,
      'image_url': url,
      'userPoints': 0,
      'chattingWith': null,
      'currentMaxLevel': 1,
    });
    return authResult;
  }

  logOutUser() async {
    await _auth.signOut();
  }
}
