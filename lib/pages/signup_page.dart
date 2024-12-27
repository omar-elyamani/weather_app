import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/components/my_button.dart';
import 'package:weather_app/components/my_textfield.dart';
import 'package:weather_app/components/my_loader.dart';
import 'package:weather_app/components/my_message.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Password visibility toggle
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Implementing the function to sign a user up
  void signUserUp() async {
    // Check if all fields are filled
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty ||confirmPasswordController.text.trim().isEmpty) {
      const MyMessage(
        message: "Please fill in all the fields.",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      ).show();
      return;
    }

    // Check if passwords match
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      const MyMessage(
        message: "The passwords don't match, please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ).show();
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Create user with Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Show success message
      const MyMessage(
        message: "Sign up was successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      ).show();

      // Redirect to login page
      Navigator.pushReplacementNamed(context, '/login');
    } 
    
    on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
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
    } 

    confirmPasswordController.clear();
    passwordController.clear();
    emailController.clear();
    setState(() { _isLoading = false; });
  }



  @override
  Widget build(BuildContext context) {
    return MyLoader(
      isLoading: _isLoading, // Display loader when _isLoading is true
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400, // Optional: Constrain the width for larger devices
                  minHeight: MediaQuery.of(context).size.height, // Take full height of screen
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud,
                        size: 150,
                        color: Colors.blue[900],
                      ),

                      // catchphrase!
                      Text(
                        'Let\'s create an account for you!',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 25),
	  
					            // email textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
					  
                      const SizedBox(height: 10),
                      
                      // confirmation password textfield
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm your password',
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // sign up button
                      MyButton(
                        width: 350,
                        text: "Sign up",
                        onTap: signUserUp,
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Log in now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}