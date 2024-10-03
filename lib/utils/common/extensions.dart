import 'dart:ui';

import 'package:flutter/material.dart';

extension ListX<T> on List<T> {
  void toggle(T value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value);
    }
  }
}

class FVariations extends FontVariation {
  FVariations._(super.axis, super.value);

  static List<FontVariation> get w500 => [const FontVariation.weight(500)];

  static List<FontVariation> get w600 => [const FontVariation.weight(600)];

  static List<FontVariation> get w700 => [const FontVariation.weight(700)];

  static List<FontVariation> get w800 => [const FontVariation.weight(800)];
}


extension NavigationPageExtension on BuildContext {
  void navigateTo(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void navigateAndReplace(Widget page) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  void navigateAndRemoveUntil(Widget page) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (context) => page),
          (Route<dynamic> route) => false,
    );
  }
}
extension SizedBoxExtension on SizedBox {
  SizedBox setHeight(double height) {
    return SizedBox(
      height: height,
      width: this.width,
    );
  }

  SizedBox setWidth(double width) {
    return SizedBox(
      height: this.height,
      width: width,
    );
  }
}