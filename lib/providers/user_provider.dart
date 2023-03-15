import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wombocombo/models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final String _authToken;
  final String _userId;
  final String username;
  final String _email;

  UserProvider(this._authToken, this._userId, this.username, this._email);

  Future<void> addUserInitially() async {
    final url = Uri.parse(
        'https://wombocomboservice-default-rtdb.europe-west1.firebasedatabase.app/users.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': _userId,
          'username': username,
          'email': _email,
        }),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
