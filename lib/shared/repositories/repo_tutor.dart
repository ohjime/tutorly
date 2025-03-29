import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorly/shared/exports.dart';

/// Repository for interfacing with tutor-related Firestore operations using domain models.
class TutorRepository {
  final TutorProvider _tutorProvider;

  /// Constructor with dependency injection for the TutorProvider.
  /// If no provider is provided, it defaults to a new instance of [TutorProvider].
  TutorRepository({TutorProvider? tutorProvider})
    : _tutorProvider = tutorProvider ?? TutorProvider();

  /// Creates a new tutor document using the tutor's UID from the TutorlyTutor model.
  Future<void> createTutor(TutorlyTutor tutor) async {
    await _tutorProvider.createTutor(uid: tutor.uid, data: tutor.toJson());
  }

  /// Retrieves a tutor document by UID and converts it to a [TutorlyTutor] instance.
  Future<TutorlyTutor?> getTutor(String uid) async {
    DocumentSnapshot doc = await _tutorProvider.getTutor(uid);
    if (doc.exists) {
      return TutorlyTutor.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Checks if a tutor document exists by UID.
  Future<bool> checkTutorExists({required String uid}) async {
    return await _tutorProvider.checkTutorExists(uid);
  }

  /// Updates a tutor document by converting the provided [TutorlyTutor] to JSON.
  Future<void> updateTutor(TutorlyTutor tutor) async {
    await _tutorProvider.updateTutor(uid: tutor.uid, data: tutor.toJson());
  }

  /// Deletes a tutor document by UID.
  Future<void> deleteTutor(String uid) async {
    await _tutorProvider.deleteTutor(uid);
  }
}
