import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:tutorly/core/models/user.dart';

/// Repository for interfacing with user-related Firestore operations using domain models.
class UserRepository {
  final cloud_firestore.FirebaseFirestore _db;

  UserRepository({cloud_firestore.FirebaseFirestore? firestore})
    : _db = firestore ?? cloud_firestore.FirebaseFirestore.instance;

  /// Creates a new user document using the provided UID.
  Future<void> createUser(String uid, User user) async {
    try {
      await _db.collection('users').doc(uid).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  /// Retrieves a user document by UID and converts it to a [User] instance.
  Future<User> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return User.empty;
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  /// Checks if a user document exists by UID.
  Future<bool> checkUserExists({required String uid}) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check user existence: ${e.toString()}');
    }
  }

  /// Updates a user document by converting the provided [User] to a map.
  Future<void> updateUser(String uid, User user) async {
    try {
      await _db.collection('users').doc(uid).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  /// Updates a user's role by UID.
  Future<void> updateUserRole(String uid, UserRole role) async {
    try {
      await _db.collection('users').doc(uid).update({
        'role': role.toString().split('.').last,
      });
    } catch (e) {
      throw Exception('Failed to update user role: ${e.toString()}');
    }
  }

  /// Updates a user's admin status by UID.
  Future<void> updateAdminStatus(String uid, bool isAdmin) async {
    try {
      await _db.collection('users').doc(uid).update({'isAdmin': isAdmin});
    } catch (e) {
      throw Exception('Failed to update admin status: ${e.toString()}');
    }
  }

  /// Deletes a user document by UID.
  Future<void> deleteUser(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }
}
