import 'package:cloud_firestore/cloud_firestore.dart';

/// Provider for Session-related Firestore operations.
class SessionProvider {
  final CollectionReference _sessions = FirebaseFirestore.instance.collection(
    'sessions',
  );

  /// Creates a new session document. A new document ID is generated automatically.
  Future<DocumentReference> createSession({
    required String tutorId,
    required String studentId,
    required int scheduledTime, // Unix timestamp
    required int duration, // Duration in minutes
    Map<String, dynamic>? location, // e.g., {"lat": 40.7128, "lng": -74.0060}
    String? address,
    required bool paymentStatus,
    String? subject,
  }) async {
    return await _sessions.add({
      'tutor_id': tutorId,
      'student_id': studentId,
      'scheduled_time': scheduledTime,
      'duration': duration,
      'location': location,
      'address': address,
      'payment_status': paymentStatus,
      'subject': subject,
    });
  }

  /// Retrieves a session document by its document ID.
  Future<DocumentSnapshot> getSession(String sessionId) async {
    return await _sessions.doc(sessionId).get();
  }

  /// Updates a session document with provided parameters.
  Future<void> updateSession({
    required String sessionId,
    int? scheduledTime, // Unix timestamp
    int? duration, // Duration in minutes
    Map<String, dynamic>? location,
    String? address,
    bool? paymentStatus,
    String? subject,
  }) async {
    Map<String, dynamic> updateData = {};
    if (scheduledTime != null) updateData['scheduled_time'] = scheduledTime;
    if (duration != null) updateData['duration'] = duration;
    if (location != null) updateData['location'] = location;
    if (address != null) updateData['address'] = address;
    if (paymentStatus != null) updateData['payment_status'] = paymentStatus;
    if (subject != null) updateData['subject'] = subject;

    if (updateData.isNotEmpty) {
      await _sessions.doc(sessionId).update(updateData);
    }
  }

  /// Deletes a session document by its document ID.
  Future<void> deleteSession(String sessionId) async {
    await _sessions.doc(sessionId).delete();
  }
}
