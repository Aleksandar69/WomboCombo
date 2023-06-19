import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/storage_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final StorageProvider storageProvider =
      Provider.of<StorageProvider>(context, listen: false);
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  XFile? _pickedImage;
  File? _convertedImage;
  bool isLoading = true;

  late String imgUrl;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = pickedImageFile;
      _convertedImage = File(_pickedImage!.path);
    });
  }

  var user;
  var username;
  var email;
  var currentUserId;

  void getUser() async {
    currentUserId = authProvider.userId;
    setState(() {
      isLoading = true;
    });
    user = await userProvider.getUser(currentUserId);

    username = user['username'];
    email = user['email'];
    imgUrl = user['image_url'];

    setState(() {
      isLoading = false;
    });
    _usernameController.text = username;
    _emailController.text = email;
  }

  void submitUserData() async {
    if (_convertedImage != null) {
      final ref =
          storageProvider.addFileOneLevel('user_image', currentUserId, 'jpg');
      await ref.putFile(File(_convertedImage!.path));

      imgUrl = await ref.getDownloadURL();
      userProvider.updateUserInfo(currentUserId, {
        'username': _usernameController.text,
        'email': _emailController.text,
        'image_url': imgUrl
      });
    } else {
      userProvider.updateUserInfo(currentUserId, {
        'username': _usernameController.text,
        'email': _emailController.text,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with default values
    getUser();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      height: 150,
                      width: 150,
                      child: Align(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: _convertedImage == null
                              ? NetworkImage(user['image_url'])
                              : FileImage(_convertedImage!) as ImageProvider,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.edit_outlined),
                      label: Text('Edit Image'),
                      onPressed: () {
                        _pickImage();
                      },
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Userame",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text('Submit'),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        submitUserData();
                        Navigator.of(context).pushReplacementNamed(
                            ProfileScreen.routeName,
                            arguments: [currentUserId, _convertedImage]);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
