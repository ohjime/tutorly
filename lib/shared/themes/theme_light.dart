import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.blue,
  useMaterial3: true,
  textTheme: const TextTheme().copyWith(
    labelSmall: const TextStyle(color: Colors.white),
    labelMedium: const TextStyle(color: Colors.white),
    labelLarge: const TextStyle(color: Colors.white),
    displaySmall: const TextStyle(color: Colors.white),
    displayMedium: const TextStyle(color: Colors.white),
    displayLarge: const TextStyle(color: Colors.white),
    headlineSmall: const TextStyle(color: Colors.white),
    headlineMedium: const TextStyle(color: Colors.white),
    headlineLarge: const TextStyle(color: Colors.white),
    titleSmall: const TextStyle(color: Colors.white),
    titleMedium: const TextStyle(color: Colors.white),
    titleLarge: const TextStyle(color: Colors.white),
  ),
);
