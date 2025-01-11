// signup_page_ui.dart
import 'package:flutter/material.dart';
import 'package:weather_app/components/my_button.dart';
import 'package:weather_app/components/my_loader.dart';
import 'package:weather_app/components/my_textfield.dart';
import 'package:weather_app/services/authentication/signup_service.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const SignupPage({
    super.key,
    required this.onTap,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupService _logic = SignupService();

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyLoader(
      isLoading: _logic.isLoading,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  minHeight: MediaQuery.of(context).size.height,
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
                      Text(
                        'Let\'s create an account for you!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: _logic.emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: _logic.passwordController,
                        hintText: 'Password',
                        obscureText: !_logic.isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _logic.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() {
                              _logic.isPasswordVisible = !_logic.isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: _logic.confirmPasswordController,
                        hintText: 'Confirm your password',
                        obscureText: !_logic.isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _logic.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() {
                              _logic.isConfirmPasswordVisible = !_logic.isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      MyButton(
                        width: 350,
                        text: "Sign up",
                        onTap: () => _logic.signUserUp(context),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: Theme.of(context).textTheme.bodySmall,
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
                      const SizedBox(height: 150),
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