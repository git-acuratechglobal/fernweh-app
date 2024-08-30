import 'package:flutter/material.dart';

abstract class Common {
  static String baseUrl = "https://fernweh.acublock.in";
  static String localUrl = "http://192.168.4.47:5000/fernweh.acublock.in";
  static String imageBaseUrl = "http://aafh.acumobi.com/storage/app/";

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }
}
