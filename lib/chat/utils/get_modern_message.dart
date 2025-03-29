// Make sure these imports are in your file:
import 'package:flutter_chat_types/flutter_chat_types.dart' as legacy;
import 'package:flutter_chat_core/flutter_chat_core.dart' as modern;

extension LegacyMessageConversion on legacy.Message {
  modern.Message toModern() {
    // Use legacy createdAt or fallback to current time in milliseconds.
    final createdAtMillis = createdAt ?? DateTime.now().millisecondsSinceEpoch;

    // Build a base JSON map with fields common to all modern messages.
    final Map<String, dynamic> baseJson = {
      'id': id,
      'authorId': author.id,
      'createdAt': createdAtMillis,
      'metadata': metadata,
      'status': _convertStatus(status),
    };

    // Extend the JSON based on the legacy message type.
    switch (type) {
      case legacy.MessageType.text:
        // Assume your legacy text message has a 'text' property.
        final legacyText = this as legacy.TextMessage;
        baseJson.addAll({
          'text': legacyText.text,
          'linkPreview': null, // Replace with actual link preview if available.
          'isOnlyEmoji': _isOnlyEmoji(legacyText.text),
          'type': 'text',
        });
        break;
      case legacy.MessageType.system:
        // Assume legacy system messages have a 'text' property.
        final legacySystem = this as legacy.SystemMessage;
        baseJson.addAll({'text': legacySystem.text, 'type': 'system'});
        break;
      case legacy.MessageType.custom:
        baseJson['type'] = 'custom';
        break;
      default:
        // For any unhandled types (like audio, file, video), fall back to unsupported.
        baseJson['type'] = 'unsupported';
    }

    // Convert the built JSON map into a modern message using the modern fromJson method.
    return modern.Message.fromJson(baseJson);
  }
}

/// Converts a legacy [Status] to a modern MessageStatus (assumed to be a String).
String? _convertStatus(legacy.Status? status) {
  if (status == null) return null;
  switch (status) {
    case legacy.Status.delivered:
      return 'delivered';
    case legacy.Status.error:
      return 'error';
    case legacy.Status.seen:
      return 'seen';
    case legacy.Status.sending:
      return 'sending';
    case legacy.Status.sent:
      return 'sent';
  }
}

/// A simple helper to determine if a text consists solely of emoji.
/// Replace with your own logic if needed.
bool _isOnlyEmoji(String text) {
  // This is a naive implementation: adjust as needed.
  final emojiRegex = RegExp(
    r'^(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff])+$',
  );
  return emojiRegex.hasMatch(text.trim());
}
