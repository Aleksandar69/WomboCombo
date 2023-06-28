import 'package:wombocombo/providers/auth_provider.dart';
import '../../widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart' as U;

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
        //Navigator.of(context).pushNamed(HomeScreen.routeName);
      } else {
        await authProvider.handleRegister(user);

        //Navigator.of(context).pushNamed(HomeScreen.routeName);
      }
    } on PlatformException catch (e) {
      var message = 'An error occured, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
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
        body: AuthForm(_submitAuthForm, _isLoading),
      ),
    );
  }
}
