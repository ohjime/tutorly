import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  /// Writes a value to storage for the given [key].
  ///
  /// Supported value types: [String], [int], [double], [bool], and [Map].
  /// [Map] values are stored as JSON strings.
  Future<void> write({
    required String key,
    required dynamic value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is Map) {
      final jsonString = jsonEncode(value);
      await prefs.setString(key, jsonString);
    } else {
      throw Exception('Unsupported value type for storage.');
    }
  }

  /// Reads a value from storage for the given [key].
  ///
  /// If the stored value is a JSON-encoded string, it attempts to decode it
  /// and returns a [Map]. Otherwise, it returns the raw value.
  Future<dynamic> read({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.get(key);

    if (storedValue is String) {
      try {
        final decoded = jsonDecode(storedValue);
        return decoded;
      } catch (_) {
        // Not a JSON string; return as is.
        return storedValue;
      }
    }
    return storedValue;
  }

  /// Removes the value associated with the given [key] from storage.
  Future<void> remove({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
