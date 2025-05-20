import 'package:equatable/equatable.dart';
import 'package:tutorly/core/core.dart';

class Tutor extends Equatable {
  const Tutor({
    required this.uid,
    required this.bio,
    required this.headline,
    required this.courses,
    required this.tutorStatus,
    required this.academicCredentials,
  });

  // Empty constructor for initialization
  static const empty = Tutor(
    uid: '',
    bio: '',
    courses: [],
    tutorStatus: TutorStatus.inactive,
    academicCredentials: [],
    headline: '',
  );

  /// The tutor's unique identifier.
  final String uid;

  /// A short biography of the tutor (optional).
  final String bio;

  /// List of courses the tutor teaches, represented as a list of [Course] objects.
  final List<Course> courses;

  /// List of the Tutor's Academic Credentials.
  final List<AcademicCredential> academicCredentials;

  /// The tutor's status (e.g., active, inactive, etc.).
  final TutorStatus tutorStatus;

  /// The tutor's headline or title.
  final String headline;

  Tutor copyWith({
    String? uid,
    String? bio,
    List<Course>? courses,
    List<AcademicCredential>? academicCredentials,
    TutorStatus? tutorStatus,
    String? headline,
  }) {
    return Tutor(
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      courses: courses ?? this.courses,
      academicCredentials: academicCredentials ?? this.academicCredentials,
      tutorStatus: tutorStatus ?? this.tutorStatus,
      headline: headline ?? this.headline,
    );
  }

  /// Serializes this [Tutor] instance into a JSON‑compatible map.
  /// Nested objects delegate to their own `toJson` implementations.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'bio': bio,
      'headline': headline,
      'tutorStatus': tutorStatus.name,
      'courses': courses.map((course) => course.toJson()).toList(),
      'academicCredentials':
          academicCredentials.map((cred) => cred.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    uid,
    bio,
    courses,
    headline,
    tutorStatus,
    academicCredentials,
  ];
}

/// Example enum for TutorStatus.
enum TutorStatus { active, inactive }
