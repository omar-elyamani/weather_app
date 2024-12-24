import 'package:flutter/material.dart';

class MyLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const MyLoader({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main content of the page
        child,

        // The loading overlay
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.5), 
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}