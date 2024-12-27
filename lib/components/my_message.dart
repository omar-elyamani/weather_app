import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyMessage extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final ToastGravity gravity;
  final Toast toastLength;

  const MyMessage({
    super.key,
    required this.message,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.gravity = ToastGravity.BOTTOM,
    this.toastLength = Toast.LENGTH_SHORT,
  });

  // Function to show the message
  void show() {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // This widget is not meant to be displayed
  }
}
