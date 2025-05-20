import 'package:flutter/material.dart';

InputDecoration appInputDecoration({
  required BuildContext context,
  required String hintText,
  String? labelText,
  IconData? icon,
  TextStyle? hintStyle,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    helperText: '',
    hintText: hintText,
    labelText: labelText,
    hintStyle:
        hintStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w100,
          letterSpacing: 2,
        ),
    alignLabelWithHint: true,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    prefixIcon:
        icon != null
            ? Padding(
              padding: const EdgeInsets.only(left: 18, right: 10),
              child: Icon(icon),
            )
            : null,
    filled: true,
    fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 2.5,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 2.5,
        color: Theme.of(context).colorScheme.errorContainer,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 2.5,
        color: Theme.of(context).colorScheme.error,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Theme.of(context).disabledColor),
    ),
  );
}
