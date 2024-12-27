import 'package:flutter/material.dart';
import 'package:weather_app/pages/login_page.dart';
import 'package:weather_app/pages/signup_page.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  // Initially show login page
  bool showLogin = true;

  // Toggle between login and signup page
  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return SignupPage(
        onTap: togglePages,
      );
    }
  }
}
