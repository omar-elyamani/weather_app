import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/login_or_signup_page.dart';
import 'package:weather_app/pages/weather_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            return const WeatherPage();
          }

          // User is NOT logged in
          else {
            return const LoginOrSignupPage();
          }
        },
      ),
    );
  }
}