import 'package:equatable/equatable.dart';
import 'package:tutorly/shared/models/_export.dart';

class TutorlyStudent extends Equatable {
  const TutorlyStudent({
    required this.uid,
    required this.highSchool,
    required this.grade,
    this.bio,
    required this.subjects,
    required this.studentStatus,
  });

  /// The student's unique identifier.
  final String uid;

  /// The student's high school.
  final String highSchool;

  /// The student's grade.
  final Grade grade;

  /// A short biography of the student (optional).
  final String? bio;

  /// List of subjects the student is interested in.
  final List<Subjects> subjects;

  /// The student's status.
  final StudentStatus studentStatus;

  /// Creates a [Student] instance from a JSON map.
  ///
  /// Assumes that `grade`, each entry in `subjects`, and `studentStatus` are stored as their enum names.
  factory TutorlyStudent.fromJson(Map<String, dynamic> json) {
    return TutorlyStudent(
      uid: json['uid'] as String,
      highSchool: json['highSchool'] as String,
      grade: Grade.values.firstWhere(
        (e) => e.toString().split('.').last == json['grade'],
      ),
      bio: json['bio'] as String?,
      subjects:
          (json['subjects'] as List<dynamic>)
              .map(
                (subject) => Subjects.values.firstWhere(
                  (e) => e.toString().split('.').last == subject,
                ),
              )
              .toList(),
      studentStatus: StudentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['studentStatus'],
      ),
    );
  }

  /// Converts this [Student] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'highSchool': highSchool,
      'grade': grade.toString().split('.').last,
      'bio': bio,
      'subjects': subjects.map((e) => e.toString().split('.').last).toList(),
      'studentStatus': studentStatus.toString().split('.').last,
    };
  }

  @override
  List<Object?> get props => [
    uid,
    highSchool,
    grade,
    bio,
    subjects,
    studentStatus,
  ];
}

// Not made a global model because its specific to only the Student Model
enum StudentStatus { active, inactive }
