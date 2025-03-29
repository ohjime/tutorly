import 'package:cloud_firestore/cloud_firestore.dart';

/// Provider for tutor-related Firestore operations.
class TutorProvider {
  final CollectionReference _tutors;

  /// Constructor with dependency injection for Firestore.
  /// If no Firestore instance is provided, the default FirebaseFirestore.instance is used.
  TutorProvider({FirebaseFirestore? firestore})
      : _tutors =
            (firestore ?? FirebaseFirestore.instance).collection('tutors');

  /// Creates a new tutor document using the tutor's UID as the document ID.
  Future<void> createTutor({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _tutors.doc(uid).set(data);
  }

  /// Retrieves a tutor document by UID.
  Future<DocumentSnapshot> getTutor(String uid) async {
    return await _tutors.doc(uid).get();
  }

  /// Checks if a tutor document exists by UID.
  Future<bool> checkTutorExists(String uid) async {
    DocumentSnapshot tutorSnapshot = await getTutor(uid);
    return tutorSnapshot.exists;
  }

  /// Updates a tutor document with the provided parameters.
  Future<void> updateTutor({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    if (data.isNotEmpty) {
      await _tutors.doc(uid).update(data);
    }
  }

  /// Deletes a tutor document by UID.
  Future<void> deleteTutor(String uid) async {
    await _tutors.doc(uid).delete();
  }
}
