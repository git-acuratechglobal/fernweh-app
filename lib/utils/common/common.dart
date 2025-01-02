import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  static void showToast({required String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffCF5253),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Color getColorFromName(String name) {
    final int hash = name.codeUnits.fold(0, (prev, element) => prev + element);
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
    ];
    return colors[hash % colors.length];
  }
}
