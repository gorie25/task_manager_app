import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  shadowColor: Colors.black.withOpacity(0.3), 
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black87,
      fontFamily: 'Roboto', 
    ),
    bodyMedium: TextStyle(
      color: Colors.black54,
      fontFamily: 'Roboto',
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(color: Colors.grey[600], fontFamily: 'Roboto'),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.grey),
    ),
  ),
  fontFamily: 'Roboto',
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  shadowColor: Colors.white.withOpacity(0.3), 
  primaryColor: Colors.purple,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'Roboto', 
    ),
    bodyMedium: TextStyle(
      color: Colors.white70,
      fontFamily: 'Roboto', 
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF1E1E1E), // Nền input tối
    filled: true,
    hintStyle: const TextStyle(color: Colors.white54, fontFamily: 'Roboto'),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.purple, width: 1.5), 
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          color: Colors.purpleAccent, width: 2), 
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.purple), 
    ),
  ),
  fontFamily: 'Roboto', // Áp dụng font Roboto cho toàn bộ theme
);