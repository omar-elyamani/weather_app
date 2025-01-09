import 'package:flutter/material.dart';
import 'package:weather_app/pages/login_page.dart';
import 'package:weather_app/pages/signup_page.dart';

class LoginOrSignupPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const LoginOrSignupPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

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
        toggleTheme: widget.toggleTheme,
        isDarkMode: widget.isDarkMode,
      );
    } else {
      return SignupPage(
        onTap: togglePages,
        toggleTheme: widget.toggleTheme,
        isDarkMode: widget.isDarkMode,
      );
    }
  }
}
