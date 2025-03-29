import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// Utility function that converts our App User into a flutter_chat_types.User
types.User getChatUser(Map<String, dynamic> userData) {
  final String? id = userData['id'] as String? ?? userData['uid'] as String?;
  if (id == null) {
    throw ArgumentError.notNull(
      'Failed to convert User into a Chat User, because the User Data does not have a id or uid field.',
    );
  } else {
    return types.User(
      id: userData['uid'] as String,
      firstName: userData['firstName'] as String?,
      lastName: userData['lastName'] as String?,
      imageUrl: userData['profilePhoto'] as String?,
      // Use metadata to store extra info
      metadata: {
        'email': userData['email'] as String?,
        'coverPhoto': userData['coverPhoto'] as String?,
      },
    );
  }
}
