import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
  var currentUser;

  void getUser() async {
    currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get(GetOptions(source: Source.server))
        .then((value) {
      user = value;
      setState(() {
        isLoading = true;
      });
    });

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
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(currentUser!.uid + '.jpg');

    await ref.putFile(File(_convertedImage!.path));

    imgUrl = await ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({
      'username': _usernameController.text,
      'email': _emailController.text,
      'image_url': imgUrl
    });
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
                            arguments: [null, _convertedImage]);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
