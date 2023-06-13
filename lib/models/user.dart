import 'dart:io';

class User {
  String? id;
  String? username;
  String? email;
  File? profileImage;
  String? password;

  User(this.username, this.email, this.profileImage, this.password);

  set currentusername(String currentUsername) {
    username = currentUsername;
  }

  set userPassword(String currentPassword) {
    password = currentPassword;
  }

  set userEmail(String currentEmail) {
    email = currentEmail;
  }

  set image(File? currentimage) {
    profileImage = currentimage;
  }
}
