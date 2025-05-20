import 'package:flutter/material.dart';

ThemeData getCoreTheme({
  required Color seedColor,
  required Brightness brightness,
}) {
  // Create the ColorScheme first
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );
  // Return ThemeData with the colorScheme
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor:
        brightness == Brightness.light
            ? colorScheme.surfaceContainerLowest
            : colorScheme.surfaceContainerHighest,
  );
}

// Use the function to create the light theme
final ThemeData lightTheme =
    getCoreTheme(
      seedColor: Colors.brown,
      brightness: Brightness.light,
    ).copyWith();
// Use the function to create the dark theme
final ThemeData darkTheme = getCoreTheme(
  seedColor: Colors.green,
  brightness: Brightness.dark,
).copyWith(textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'));
