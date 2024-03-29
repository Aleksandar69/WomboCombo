import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/storage_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/models/user.dart' as u;

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

  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  XFile? _pickedImage;
  File? _convertedImage;
  bool isLoading = true;
  bool hasError = false;

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

  late u.User user;
  var userFetched;
  late String username;
  late String email;
  var currentUserId;
  var password = '';
  void getUser() async {
    currentUserId = authProvider.userId;
    setState(() {
      isLoading = true;
    });
    userFetched = await userProvider.getUser(currentUserId);

    username = userFetched['username'];
    email = userFetched['email'];
    imgUrl = userFetched['image_url'];

    setState(() {
      isLoading = false;
    });
    _usernameController.text = username;
    _emailController.text = email;
  }

  void submitUserData() async {
    setState(() {
      isLoading = true;
    });
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
    try {
      if (_passwordController.text.isNotEmpty) {
        if (_passwordController.text != _confirmPasswordController.text) {
          SnackbarHelper.showSnackbarError(
              context, 'Passwords do not match', 'Error');
          hasError = true;
        } else {
          await authProvider.changePassword(password);
        }
      }
    } on FirebaseAuthException catch (e) {
      SnackbarHelper.showSnackbarError(
        context,
        e.message!,
        'Error',
      );
      hasError = true;
    } catch (e) {
      var message = 'An error occured, please try again';
      SnackbarHelper.showSnackbarError(
        context,
        message,
        'Error',
      );
      hasError = true;
    }
    try {
      if (email != _emailController.text) {
        await authProvider.changeEmail(_emailController.text);
      }
    } on FirebaseAuthException catch (e) {
      SnackbarHelper.showSnackbarError(
        context,
        e.message!,
        'Error',
      );
      hasError = true;
    } catch (e) {
      var message = 'An error occured, please try again';
      SnackbarHelper.showSnackbarError(
        context,
        message,
        'Error',
      );
      hasError = true;
    }

    if (!hasError)
      SnackbarHelper.showSnackbarSuccess(
        context,
        'Action successful',
        'Success',
      );

    user = u.User(_usernameController.text, _emailController.text, null, imgUrl,
        null, null, null, null);
    Navigator.of(context).pop(user);
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
                key: _formKey,
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
                              ? NetworkImage(userFetched['image_url'])
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
                          validator: (value) {
                            if (value.toString().isEmpty ||
                                value == '' ||
                                value == null) {
                              return "Field can't be empty";
                            }
                            return null;
                          },
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.toString().isEmpty ||
                              value == '' ||
                              value == null) {
                            return "Field can't be empty";
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please check your email format';
                          }
                          return null;
                        },
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
                          validator: (value) {
                            if (value != _confirmPasswordController.text) {
                              return "Passwords don't match";
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Passwords don't match";
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm  Password",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          }),
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
                        if (_formKey.currentState!.validate()) {
                          submitUserData();
                        }
                      },
                      //  username.isNotEmpty && email.isNotEmpty
                      //     ? () {
                      //         submitUserData();
                      //       }
                      //     : null,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
