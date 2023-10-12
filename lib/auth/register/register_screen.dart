import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_3/auth/login/login_screen.dart';
import 'package:flutter_app_todo_sun_3/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_sun_3/dialog_utils.dart';
import 'package:flutter_app_todo_sun_3/firebase_utils.dart';
import 'package:flutter_app_todo_sun_3/home/home_screen.dart';
import 'package:flutter_app_todo_sun_3/model/my_user.dart';
import 'package:flutter_app_todo_sun_3/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'Amira');

  var emailController = TextEditingController(text: 'amira@route.com');

  var passwordController = TextEditingController(text: '123456');

  var confirmationPasswordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/main_background.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    CustomTextFormField(
                      label: 'User Name',
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter userName';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter email address';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Password',
                      keyboardType: TextInputType.number,
                      controller: passwordController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter password';
                        }
                        if (text.length < 6) {
                          return 'Password should be at least 6 chars';
                        }
                        return null;
                      },
                      isPassword: true,
                    ),
                    CustomTextFormField(
                      label: 'Confirmation Password',
                      keyboardType: TextInputType.number,
                      controller: confirmationPasswordController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter confirmation password';
                        }
                        if (text != passwordController.text) {
                          return "Password doesn't match.";
                        }
                        return null;
                      },
                      isPassword: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          register();
                        },
                        child: Text(
                          'Register',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          /// navigate to login screen
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                        },
                        child: Text('Already have an account'))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      /// register
      // todo: show loading
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);
        await FirebaseUtils.addUserToFireStore(myUser);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(myUser);
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo: show message
        DialogUtils.showMessage(context, 'Register Succuessfully',
            title: 'Success', posActionName: 'Ok', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // todo: hide loading
          DialogUtils.hideLoading(context);
          // todo: show message
          DialogUtils.showMessage(context, 'The password provided is too weak.',
              title: 'Error', posActionName: 'Ok');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          // todo: show message
          DialogUtils.showMessage(
              context, 'The account already exists for that email',
              title: 'Error', posActionName: 'Ok');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        // todo: show message
        DialogUtils.showMessage(
          context,
          '${e.toString()}',
          posActionName: 'Ok',
          title: 'Error',
        );
      }
    }
  }
}
