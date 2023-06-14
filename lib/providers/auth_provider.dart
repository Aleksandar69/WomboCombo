import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as U;
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _email;
  String? _username;
  final _auth = FirebaseAuth.instance;
  AuthRepository authRepo = AuthRepository();

  handleLogin(U.User user) async {
    UserCredential authResult = await authRepo.loginUser(user);
    notifyListeners();
    _userId = _auth.currentUser?.uid;
    _username = user.username;
    _email = user.email;
    return authResult;
  }

  handleRegister(U.User user) async {
    UserCredential authResult = await authRepo.registerUser(user);
    _userId = _auth.currentUser?.uid;
    _username = user.username;
    _email = user.email;
    notifyListeners();
    return authResult;
  }

  void logOut() async {
    await authRepo.logOutUser();
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
