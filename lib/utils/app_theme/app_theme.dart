import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/extensions.dart';
import '../page_slider/page_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTheme {
  static final ThemeData _themeData = ThemeData(
    fontFamily: "Plus Jakarta Sans",
    colorScheme: const ColorScheme.light(
      surface: Colors.white,
      surfaceTint: Colors.white,
      primary: Color(0xff1A72FF),
      secondary: Color(0xffCF5253),
      tertiary: Color(0xFF12B347),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xffE2E2E2)),
    bottomSheetTheme:
        const BottomSheetThemeData(surfaceTintColor: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xffE2E2E2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xffE2E2E2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xffCF5253), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xffb00020), width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xffb00020), width: 2),
      ),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: const Color(0xff1A72FF),
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          fontSize: 18,
          fontFamily: "Plus Jakarta Sans",
          fontVariations: FVariations.w700,
        ),
      ),
    ),
    appBarTheme:
        const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        side: const BorderSide(color: Color(0xffE2E2E2)),
        textStyle: TextStyle(
          fontSize: 18,
          fontFamily: "Plus Jakarta Sans",
          fontVariations: FVariations.w700,
        ),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: RightToLeftPageTransitionsBuilder(),
      TargetPlatform.iOS: RightToLeftPageTransitionsBuilder()
    }),
  );
  static  ThemeData get themeData => _themeData;
}

final appThemeProvider = StateProvider<ThemeData>((ref) => AppTheme.themeData);
