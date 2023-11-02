import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wombocombo/models/user.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import '../video_image_widgets/user_image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class AuthForm extends StatefulWidget {
  final void Function(User user, bool isLogin) submitFn;
  final Future<void> Function() googleSignIn;

  final bool isLoading;

  const AuthForm(this.submitFn, this.isLoading, this.googleSignIn);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  User user = User(null, null, null, null, null, null, null, null);

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _pickedImage(File? image) {
    user.profileImage = image;
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (user.profileImage == null && !_isLogin) {
      var file;
      await getDefaultImage().then((value) => file = value);
      user.profileImage = file;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(user, _isLogin);
    }
  }

  Future<File> getDefaultImage() async {
    final byteData =
        await rootBundle.load('assets/images/default_profile_clear.png');

    final file = File(
        '${(await getTemporaryDirectory()).path}/images/default-profile.jpg');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (!_isLogin) UserImagePicker(_pickedImage),
              TextFormField(
                key: ValueKey('email'),
                onSaved: (value) {
                  user.email = value!;
                },
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
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                ),
              ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('username'),
                  onSaved: (value) {
                    user.username = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return 'Username must be at least 4 characters long.';
                    }
                    if (value.length > 20) {
                      return "Username mustn't be more than 20 characters long.";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
              TextFormField(
                key: ValueKey('password'),
                controller: _passwordController,
                onSaved: (value) {
                  user.password = value!;
                },
                validator: (value) {
                  if (value != _confirmPasswordController.text) {
                    return "Passwords don't match";
                  }
                  if (value!.isEmpty || value.length < 7) {
                    return 'Password must be at least 7 characters long.';
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              if (!_isLogin)
                TextFormField(
                  controller: _confirmPasswordController,
                  key: ValueKey('confirmPassword'),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Passwords don't match";
                    }
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                ),
              const SizedBox(
                height: 12,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  onPressed: _trySubmit,
                  child: Text(_isLogin ? 'Login' : 'Create Account'),
                ),
              if (!widget.isLoading)
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I already have an account'),
                ),
              // TextButton(
              //     onPressed: () {
              //       widget.googleSignIn();
              //     },
              //     child: Text('Sign in with google account')),
            ]),
          ),
        )),
      ),
    );
  }
}
