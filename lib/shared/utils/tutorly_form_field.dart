import 'package:flutter/material.dart';

InputDecoration tutorlyInputDecoration({
  String? hintText,
  Widget? suffixIcon,
  required BuildContext context,
}) {
  const double borderWidth = 3.0;
  final Color borderColor = Colors.blueGrey.withValues(alpha: 0.6);
  final Color disabledBorderColor = Colors.blueGrey;
  final Color focusedBorderColor = Colors.white;
  const Color errorBorderColor = Colors.red;

  return InputDecoration(
    errorStyle: TextStyle(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.red,
    ),
    filled: true,
    helperText: '',
    hintText: hintText,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth * 0.9,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: disabledBorderColor,
        width: borderWidth,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: focusedBorderColor,
        width: borderWidth,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: errorBorderColor,
        width: borderWidth,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: errorBorderColor,
        width: borderWidth,
      ),
    ),
  );
}
