import 'package:book_app/screens/login_screen.dart';
import 'package:book_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginScreen(onClickedSignUp: toggle)
        : SignUpScreen(onClickedSignUp: toggle);
  }

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
