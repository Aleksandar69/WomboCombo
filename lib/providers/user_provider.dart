import 'package:flutter/material.dart';
import 'package:wombocombo/models/user.dart';
import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  UserRepository userRespository = UserRepository();

  updateUserInfo(String userId, updateData) {
    return userRespository.updateUserInfo(userId, updateData);
  }

  getUser(userId) async {
    return userRespository.getUser(userId);
  }

  addUser(User user, imgUrl) {
    return userRespository.addUser(user, imgUrl);
  }

  getUserFilterIsEqualTo(arg1, arg2) {
    return userRespository.getUserFilterIsEqualTo(arg1, arg2);
  }

  getAllUsersWithOrderAndLimit(orderBy, isDescending, limit) {
    return userRespository.getAllUsersWithOrderAndLimit(
        orderBy, isDescending, limit);
  }
}
