import 'package:flutter/material.dart';

InputDecoration onboardingFormStyle({
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
    fillColor: Colors.white,
    hintText: hintText,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth * 0.9,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: disabledBorderColor,
        width: borderWidth,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: focusedBorderColor,
        width: borderWidth,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: errorBorderColor,
        width: borderWidth,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: errorBorderColor,
        width: borderWidth,
      ),
    ),
  );
}
