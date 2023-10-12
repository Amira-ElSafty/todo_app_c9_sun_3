import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_3/auth/register/register_navigator.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  /// hold data - handle logic
  late RegisterNavigator navigator;

  void register(String email, String password) async {
    /// register
    // todo: show loading
    navigator.showMyLoading();
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // MyUser myUser = MyUser(
      //     id: credential.user?.uid ?? '',
      //     name: nameController.text,
      //     email: emailController.text);
      // await FirebaseUtils.addUserToFireStore(myUser);
      // var authProvider = Provider.of<AuthProvider>(context, listen: false);
      // authProvider.updateUser(myUser);
      // todo: hide loading
      navigator.hideMyLoading();
      // todo: show message
      navigator.showMyMessage('Register Succuessfully');
      // DialogUtils.showMessage(context, 'Register Succuessfully',
      //     title: 'Success', posActionName: 'Ok', posAction: () {
      //       Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      //     });
      print('register succuessfully');
      print(credential.user?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // todo: hide loading
        navigator.hideMyLoading();
        // todo: show message
        navigator.showMyMessage('The password provided is too weak.');
        // DialogUtils.showMessage(context, 'The password provided is too weak.',
        //     title: 'Error', posActionName: 'Ok');
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        navigator.hideMyLoading();
        // todo: show message
        navigator.showMyMessage('The account already exists for that email.');
        // DialogUtils.hideLoading(context);
        // // todo: show message
        // DialogUtils.showMessage(
        //     context, 'The account already exists for that email',
        //     title: 'Error', posActionName: 'Ok');
        print('The account already exists for that email.');
      }
    } catch (e) {
      navigator.hideMyLoading();
      // todo: show message
      navigator.showMyMessage(e.toString());
      // DialogUtils.hideLoading(context);
      // // todo: show message
      // DialogUtils.showMessage(
      //   context,
      //   '${e.toString()}',
      //   posActionName: 'Ok',
      //   title: 'Error',
      // );
      print(e);
    }
  }
}
