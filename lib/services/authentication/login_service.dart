import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/components/my_message.dart';

class LoginService {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  // Function to log a user in
  Future<void> logUserIn(BuildContext context) async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      const MyMessage(
        message: "Please fill in both fields.",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      ).show();
      return;
    }

    try {
      isLoading = true;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Show success message
      const MyMessage(
        message: "Log in was successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      ).show();

      // Redirect to the weather page
      Navigator.pushReplacementNamed(context, '/weather');
      dispose();
    } catch (e) {
      // Show error message
      const MyMessage(
        message: "Invalid credentials, please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ).show();
    } finally {
      isLoading = false;
    }
  }

  // Function to log a user out
  Future<void> logUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Dispose controllers when no longer needed
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
