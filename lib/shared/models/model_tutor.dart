import 'package:equatable/equatable.dart';
import 'package:tutorly/shared/models/_export.dart';

class TutorlyTutor extends Equatable {
  const TutorlyTutor({
    required this.uid,
    required this.subjects,
    required this.grades,
    required this.tutorStatus,
    required this.availability,
    required this.almaMater,
    required this.credential,
    this.bio,
  });

  /// The tutor's unique identifier.
  final String uid;

  /// List of subjects the tutor teaches, represented as a list of [Subjects] enum values.
  final List<Subjects> subjects;

  /// List of grades the tutor can teach.
  final List<int> grades;

  /// The tutor's status (e.g., active, inactive, etc.).
  final TutorStatus tutorStatus;

  /// Tutor's availability details.
  final Map<String, dynamic> availability;

  /// The tutor's alma mater.
  final String almaMater;

  /// The tutor's credential details.
  final String credential;

  /// A short biography of the tutor (optional).
  final String? bio;

  /// Creates a [TutorlyTutor] from a JSON map.
  factory TutorlyTutor.fromJson(Map<String, dynamic> json) {
    return TutorlyTutor(
      uid: json['uid'] as String,
      subjects:
          (json['subjects'] as List<dynamic>)
              .map(
                (s) => Subjects.values.firstWhere(
                  (e) => e.toString().split('.').last == s as String,
                ),
              )
              .toList(),
      grades: List<int>.from(json['grades'] as List<dynamic>),
      tutorStatus: TutorStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['tutorStatus'] as String,
      ),
      availability: Map<String, dynamic>.from(
        json['availability'] as Map<dynamic, dynamic>,
      ),
      almaMater: json['almaMater'] as String,
      credential: json['credential'] as String,
      bio: json['bio'] as String?,
    );
  }

  /// Converts this [TutorlyTutor] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'subjects': subjects.map((s) => s.toString().split('.').last).toList(),
      'grades': grades,
      'tutorStatus': tutorStatus.toString().split('.').last,
      'availability': availability,
      'almaMater': almaMater,
      'credential': credential,
      'bio': bio,
    };
  }

  @override
  List<Object?> get props => [
    uid,
    subjects,
    grades,
    tutorStatus,
    availability,
    almaMater,
    credential,
    bio,
  ];
}

/// Example enum for TutorStatus.
enum TutorStatus { active, inactive }
