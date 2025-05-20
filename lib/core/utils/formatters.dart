import 'package:flutter/services.dart';

final capitalize = TextInputFormatter.withFunction((oldValue, newValue) {
  if (newValue.text.isEmpty) return newValue;
  return TextEditingValue(
    text: newValue.text[0].toUpperCase() + newValue.text.substring(1),
    selection: newValue.selection,
  );
});

final capitalizeWords = TextInputFormatter.withFunction((oldValue, newValue) {
  if (newValue.text.isEmpty) return newValue;
  final words = newValue.text.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  });
  return TextEditingValue(
    text: capitalizedWords.join(' '),
    selection: newValue.selection,
  );
});
