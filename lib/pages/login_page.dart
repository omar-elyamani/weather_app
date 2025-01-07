import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/components/my_button.dart';
//import 'package:weather_app/components/my_square_tile.dart';
import 'package:weather_app/components/my_textfield.dart';
import 'package:weather_app/components/my_loader.dart';
import 'package:weather_app/components/my_message.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Password visibility toggle
  bool _isPasswordVisible = false;

  // Implementing the function to log a user in
  void logUserIn() async {
    // Check if both fields are filled
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      const MyMessage(
        message: "Please fill in both fields.",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      ).show();
      return; // Exit the function early
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
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

      // Redirect to weather page
      Navigator.pushReplacementNamed(context, '/weather');
    } catch (e) {
      // Show error message
      const MyMessage(
        message: "Invalid credentials, please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      ).show();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyLoader(
      isLoading: _isLoading, // Display loader when _isLoading is true
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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

                      // Catchphrase!
                      Text(
                        'Welcome back to your weather app!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 25),

                      // Email textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      // Password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Sign in button
                      MyButton(
                        width: 350,
                        text: "Log in",
                        onTap: logUserIn,
                      ),

                      const SizedBox(height: 25),

                      // Or continue with
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or continue with',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Google sign-in button
                     /* const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google button
                          SquareTile(imagePath: 'assets/google.webp'),
                        ],
                      ),*/

                      const SizedBox(height: 20),

                      // Not a member? Register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Register now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
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