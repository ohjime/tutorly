import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorly/shared/exports.dart';

/// Repository for interfacing with student-related Firestore operations using domain models.
class StudentRepository {
  final StudentProvider _studentProvider;

  /// Constructor with dependency injection for the StudentProvider.
  /// If no provider is provided, it defaults to a new instance of [StudentProvider].
  StudentRepository({StudentProvider? studentProvider})
    : _studentProvider = studentProvider ?? StudentProvider();

  /// Creates a new student document using the student's UID from the TutorlyStudent model.
  Future<void> createStudent(TutorlyStudent student) async {
    await _studentProvider.createStudent(
      uid: student.uid,
      data: student.toJson(),
    );
  }

  /// Retrieves a student document by UID and converts it to a [TutorlyStudent] instance.
  Future<TutorlyStudent?> getStudent(String uid) async {
    DocumentSnapshot doc = await _studentProvider.getStudent(uid);
    if (doc.exists) {
      return TutorlyStudent.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Checks if a student document exists by UID.
  Future<bool> checkStudentExists({required String uid}) async {
    return await _studentProvider.checkStudentExists(uid);
  }

  /// Updates a student document by converting the provided [TutorlyStudent] to JSON.
  Future<void> updateStudent(TutorlyStudent student) async {
    await _studentProvider.updateStudent(
      uid: student.uid,
      data: student.toJson(),
    );
  }

  /// Deletes a student document by UID.
  Future<void> deleteStudent(String uid) async {
    await _studentProvider.deleteStudent(uid);
  }
}
