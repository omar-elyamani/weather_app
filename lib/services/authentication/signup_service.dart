// signup_page_logic.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/components/my_message.dart';

class SignupService {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  // Function to sign the user up
  Future<void> signUserUp(BuildContext context) async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      const MyMessage(
        message: "Please fill in all the fields.",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      ).show();
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      const MyMessage(
        message: "The passwords don't match, please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ).show();
      return;
    }

    try {
      isLoading = true;

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      const MyMessage(
        message: "Sign up was successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      ).show();

      Navigator.pushReplacementNamed(context, '/weather');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already in use.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        default:
          errorMessage = "An error occurred. Please try again.";
      }

      MyMessage(
        message: errorMessage,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ).show();
    } finally {
      isLoading = false;
    }
  }

  // Dispose controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
