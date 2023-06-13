import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as U;

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _email;
  String? _username;
  final _auth = FirebaseAuth.instance;

  handleLogin(U.User user) async {
    UserCredential authResult = await _auth.signInWithEmailAndPassword(
      email: user.email!,
      password: user.password!,
    );
    notifyListeners();
    _userId = _auth.currentUser?.uid;
    _username = user.username;
    _email = user.email;
    return authResult;
  }

  handleRegister(U.User user) async {
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
    _userId = _auth.currentUser?.uid;
    _username = user.username;
    _email = user.email;
    notifyListeners();
    return authResult;
  }

  void logOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  String? get email {
    return _email;
  }

  String? get username {
    return _username;
  }

  String? get userId {
    return _auth.currentUser?.uid;
  }
}
