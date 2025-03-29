import 'package:cloud_firestore/cloud_firestore.dart';

/// Provider for student-related Firestore operations.
class StudentProvider {
  final CollectionReference _students;

  /// Constructor with dependency injection for Firestore.
  /// If no Firestore instance is provided, the default FirebaseFirestore.instance is used.
  StudentProvider({FirebaseFirestore? firestore})
      : _students =
            (firestore ?? FirebaseFirestore.instance).collection('students');

  /// Creates a new student document using the student's UID as the document ID.
  Future<void> createStudent({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _students.doc(uid).set(data);
  }

  /// Retrieves a student document by UID.
  Future<DocumentSnapshot> getStudent(String uid) async {
    return await _students.doc(uid).get();
  }

  /// Checks if a student document exists by UID.
  Future<bool> checkStudentExists(String uid) async {
    DocumentSnapshot studentSnapshot = await getStudent(uid);
    return studentSnapshot.exists;
  }

  /// Updates a student document with the provided data.
  Future<void> updateStudent({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    if (data.isNotEmpty) {
      await _students.doc(uid).update(data);
    }
  }

  /// Deletes a student document by UID.
  Future<void> deleteStudent(String uid) async {
    await _students.doc(uid).delete();
  }
}
