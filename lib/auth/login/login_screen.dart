import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_3/auth/login/login_navigator.dart';
import 'package:flutter_app_todo_sun_3/auth/login/login_screen_view_model.dart';
import 'package:flutter_app_todo_sun_3/auth/register/register_screen.dart';
import 'package:flutter_app_todo_sun_3/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_sun_3/dialog_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator {
  var emailController = TextEditingController(text: 'amira@route.com');

  var passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  LoginScreenViewModel viewModel = LoginScreenViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
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
                        label: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        controller: viewModel.emailController,
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
                        controller: viewModel.passwordController,
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Text(
                            "Don't have an account ? ",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextButton(
                              onPressed: () {
                                /// navigate to register screen
                                Navigator.of(context)
                                    .pushNamed(RegisterScreen.routeName);
                              },
                              child: Text(
                                'SignUp',
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      viewModel.login();
    }
  }

  @override
  void hideMyLoading() {
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyMessage(String message) {
    DialogUtils.showMessage(
      context, message, title: 'Succuess',
      posActionName: 'Ok',
      // posAction: (){
      // Navigator.pushNamed(context, HomeScreen.routeName);
      // }
    );
  }

  @override
  void showMyLoading() {
    DialogUtils.showLoading(context, 'Loading...');
  }
}
