import 'package:cloud_firestore/cloud_firestore.dart';
import '../exports.dart';

/// Repository for interfacing with user-related Firestore operations using domain models.
class UserRepository {
  final UserProvider _userProvider;

  /// Constructor with dependency injection for the UserProvider.
  /// If no provider is provided, it defaults to a new instance of [UserProvider].
  UserRepository({UserProvider? userProvider})
    : _userProvider = userProvider ?? UserProvider();

  /// Creates a new user document using the user's UID from the TutorlyUser model.
  Future<void> createUser(TutorlyUser user) async {
    await _userProvider.createUser(uid: user.id, data: user.toJson());
  }

  /// Retrieves a user document by UID and converts it to a [TutorlyUser] instance.
  Future<TutorlyUser?> getUser(String uid) async {
    DocumentSnapshot doc = await _userProvider.getUser(uid);
    if (doc.exists) {
      return TutorlyUser.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Checks if a user document exists by UID.
  Future<bool> checkUserExists({required String uid}) async {
    return await _userProvider.checkUserExists(uid);
  }

  /// Updates a user document by converting the provided [TutorlyUser] to JSON.
  Future<void> updateUser(TutorlyUser user) async {
    await _userProvider.updateUser(uid: user.id, data: user.toJson());
  }

  /// Deletes a user document by UID.
  Future<void> deleteUser(String uid) async {
    await _userProvider.deleteUser(uid);
  }
}
