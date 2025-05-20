import 'package:equatable/equatable.dart';

class AcademicCredential extends Equatable {
  final String institution;
  final AcademicCredentialLevel level;
  final String fieldOfStudy;
  final String focus;
  final DateTime dateIssued;
  final String imageUrl;

  const AcademicCredential({
    required this.institution,
    required this.level,
    required this.fieldOfStudy,
    required this.focus,
    required this.dateIssued,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'level': level.name,
      'fieldOfStudy': fieldOfStudy,
      'focus': focus,
      'dateIssued': dateIssued.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory AcademicCredential.fromJson(Map<String, dynamic> json) {
    return AcademicCredential(
      institution: json['institution'] as String,
      level: AcademicCredentialLevel.values.firstWhere(
        (e) => e.name == json['level'],
      ),
      fieldOfStudy: json['fieldOfStudy'] as String,
      focus: json['focus'] as String,
      dateIssued: DateTime.parse(json['dateIssued'] as String),
      imageUrl: json['imageUrl'] as String,
    );
  }

  AcademicCredential copyWith({
    String? institution,
    AcademicCredentialLevel? level,
    String? fieldOfStudy,
    String? focus,
    DateTime? dateIssued,
    String? imageUrl,
  }) {
    return AcademicCredential(
      institution: institution ?? this.institution,
      level: level ?? this.level,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      focus: focus ?? this.focus,
      dateIssued: dateIssued ?? this.dateIssued,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Returns an empty instance of [AcademicCredential].

  AcademicCredential.empty()
    : institution = '',
      level = AcademicCredentialLevel.bachelor,
      fieldOfStudy = '',
      focus = '',
      dateIssued = DateTime.now(),
      imageUrl = '';

  @override
  List<Object?> get props => [
    institution,
    level,
    fieldOfStudy,
    focus,
    dateIssued,
    imageUrl,
  ];

  /// Returns true if this credential has no meaningful data.
  bool get isEmpty =>
      institution.trim().isEmpty &&
      fieldOfStudy.trim().isEmpty &&
      imageUrl.trim().isEmpty;
}

enum AcademicCredentialLevel {
  highschool,
  certificate,
  diploma,
  bachelor,
  masters,
  doctorate;

  // We give this enum these properties to make it
  // very easy to filter when searching for tutors
  // by what academic credential level they have.

  bool operator <(AcademicCredentialLevel other) {
    return index < other.index;
  }

  bool operator >(AcademicCredentialLevel other) {
    return index > other.index;
  }

  bool operator <=(AcademicCredentialLevel other) {
    return index <= other.index;
  }

  bool operator >=(AcademicCredentialLevel other) {
    return index >= other.index;
  }
}
