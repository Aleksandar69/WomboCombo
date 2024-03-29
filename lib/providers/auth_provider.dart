import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as U;
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _email;
  String? _username;
  final _auth = FirebaseAuth.instance;
  AuthRepository authRepo = AuthRepository();

  handleLogin(U.User user) async {
    try {
      UserCredential authResult = await authRepo.loginUser(user);
      notifyListeners();
      _userId = _auth.currentUser?.uid;
      _username = user.username;
      _email = user.email;
      return authResult;
    } catch (e) {
      throw e;
    }
  }

  changePassword(newPassword) async {
    try {
      await authRepo.changePassowrd(newPassword);
    } catch (e) {
      throw e;
    }
  }

  changeEmail(newEmail) async {
    try {
      await authRepo.changeEmail(newEmail);
    } catch (e) {
      throw e;
    }
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
