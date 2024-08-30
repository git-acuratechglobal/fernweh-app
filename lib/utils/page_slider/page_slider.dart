import 'package:flutter/material.dart';

class RightToLeftPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Start from right side
        end: const Offset(0.0, 0.0), // Slide to the left
      ).animate(animation),
      child: child,
    );
  }
}
