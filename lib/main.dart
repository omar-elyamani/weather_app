import 'package:flutter/material.dart';
import 'package:weather_app/pages/auth_page.dart';
import 'package:weather_app/pages/login_or_signup_page.dart';
import 'package:weather_app/pages/login_page.dart';
import 'package:weather_app/pages/signup_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // Function to toggle the theme mode
  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode, // Apply the current theme mode
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(
              toggleTheme: _toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
            
        '/login': (context) => LoginPage(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              toggleTheme: _toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),

        '/signup': (context) => SignupPage(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              toggleTheme: _toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),

        '/login_or_signup': (context) => LoginOrSignupPage(
              toggleTheme: _toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),

        '/weather': (context) => WeatherPage(
              toggleTheme: _toggleThemeMode,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
      },
    );
  }
}
