import 'dart:math';

import 'package:flutter/material.dart';

abstract class Common {
  static String baseUrl = "https://fernweh.acublock.in";
  static String localUrl = "http://203.129.220.19:5000/fernweh.acublock.in";
  static String imageBaseUrl = "http://aafh.acumobi.com/storage/app/";

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }
 static Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
