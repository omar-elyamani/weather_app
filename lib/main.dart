import 'package:flutter/material.dart';
import 'package:weather_app/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _updateThemeBasedOnTime();
  }

  // Function to update theme mode based on time
  void _updateThemeBasedOnTime() {
    final now = TimeOfDay.now();
    const sunset = TimeOfDay(hour: 18, minute: 30); 

    // Check if current time is past sunset
    if (now.hour > sunset.hour || (now.hour == sunset.hour && now.minute >= sunset.minute)) {
      setState(() {
        _themeMode = ThemeMode.dark;
      });
    } else {
      setState(() {
        _themeMode = ThemeMode.light;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: _themeMode, // Apply the current theme mode
      home: const AuthPage(),
    );
  }
}
