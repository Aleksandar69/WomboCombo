import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/screens/home_screen.dart';
import '../../widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart' as U;
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late U.User user;
  var _isLoading = false;
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late GoogleSignIn _googleSignIn;

  var message = 'An error occured, please check your credentials!';

  _submitAuthForm(
    U.User user,
    bool isLogin,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        await authProvider.handleLogin(
          user,
        );
        Navigator.of(context).pushNamed(HomeScreen.routeName);
      } else {
        await authProvider.handleRegister(user);

        Navigator.of(context).pushNamed(HomeScreen.routeName);
      }
    } on PlatformException catch (e) {
      var message = 'An error occured, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      SnackbarHelper.showSnackbarError(
        context,
        message,
        "Oh snap!",
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        message = e.message!;
      }
      SnackbarHelper.showSnackbarError(
        context,
        message,
        "Oh snap!",
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      SnackbarHelper.showSnackbarError(
        context,
        message,
        "Oh snap!",
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleGoogleSignin() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading, _handleGoogleSignin),
      ),
    );
  }
}
