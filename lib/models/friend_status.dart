import 'package:flutter/material.dart';

class FriendStatus with ChangeNotifier {
  String? id;
  String? user1Id;
  String? user2Id;
  int? status;
  FriendStatus(this.user1Id, this.user2Id, this.status);
}
