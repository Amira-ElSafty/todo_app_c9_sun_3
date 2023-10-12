import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_3/auth/login/login_navigator.dart';
import 'package:flutter_app_todo_sun_3/providers/auth_provider.dart';

class LoginScreenViewModel extends ChangeNotifier {
  /// hold data - handle logic
  late LoginNavigator navigator;

  late AuthProvider authProvider;

  var emailController = TextEditingController(text: 'amira10@route.com');
  var passwordController = TextEditingController();

  void login() async {
    /// login
    navigator.showMyLoading();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      print(credential.user?.uid ?? "");

      // var user = await FirebaseUtils.readUserFromFireStore(
      //     credential.user?.uid ?? "");
      // if (user == null) {
      //   return;
      // }
      // var authProvider = Provider.of<AuthProvider>(context, listen: false);
      // authProvider.updateUser(user);
      // // todo: hide loading
      navigator.hideMyLoading();
      // todo: show message
      navigator.showMyMessage('Login Succuessfully');

      print(credential.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        navigator.hideMyLoading();
        // todo: show message
        navigator
            .showMyMessage('No user found for that email or Wrong password.');
      }
    } catch (e) {
      navigator.hideMyLoading();
      // todo: show message
      navigator.showMyMessage(e.toString());
    }
  }
}
