import 'package:cloud_firestore/cloud_firestore.dart';

/// Provider for user-related Firestore operations.
class UserProvider {
  final CollectionReference _users;

  /// Constructor with dependency injection for Firestore.
  /// If no Firestore instance is provided, the default FirebaseFirestore.instance is used.
  UserProvider({FirebaseFirestore? firestore})
    : _users = (firestore ?? FirebaseFirestore.instance).collection('users');

  /// Creates a new user document using the user's UID as the document ID.
  Future<void> createUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _users.doc(uid).set(data);
  }

  /// Retrieves a user document by UID.
  Future<DocumentSnapshot> getUser(String uid) async {
    return await _users.doc(uid).get();
  }

  /// Checks if a user document exists by UID.
  Future<bool> checkUserExists(String uid) async {
    DocumentSnapshot userSnapshot = await getUser(uid);
    return userSnapshot.exists;
  }

  /// Updates a user document with the provided data.
  Future<void> updateUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    if (data.isNotEmpty) {
      await _users.doc(uid).update(data);
    }
  }

  /// Deletes a user document by UID.
  Future<void> deleteUser(String uid) async {
    await _users.doc(uid).delete();
  }
}
