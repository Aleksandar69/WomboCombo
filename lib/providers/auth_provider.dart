import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _email;
  String? _username;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token.toString();
    }
  }

  String? get email {
    return _email;
  }

  String? get username {
    return _username;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment, String username) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyATcnwxr5043ztLPQ0pdgMNrVQ1HaICkQ8');

    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final responseData = json.decode(response.body);

    _username = username;
    _email = responseData['email'];
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseData['expiresIn']),
      ),
    );

    notifyListeners();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate?.toIso8601String(),
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', userData);

    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword', '');
  }

  Future<void> signup(String email, String password, String username) async {
    return _authenticate(email, password, 'signUp', username);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(prefs.getString('userData').toString())
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'].toString();
    _userId = extractedData['uderId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  void logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData'); AKO KORISTIS VISE STVARI U USER PREFS
    prefs.clear();
  }
}
