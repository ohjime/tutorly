import 'package:equatable/equatable.dart';
import 'package:tutorly/core/core.dart';

class Course extends Equatable {
  final Subject subjectType;
  final Grade generalLevel;

  const Course({required this.subjectType, required this.generalLevel});

  Course copyWith({Subject? subjectType, Grade? generalLevel}) {
    return Course(
      subjectType: subjectType ?? this.subjectType,
      generalLevel: generalLevel ?? this.generalLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {'subjectType': subjectType.name, 'generalLevel': generalLevel.name};
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      subjectType: Subject.values.firstWhere(
        (e) => e.name == json['subjectType'],
      ),
      generalLevel: Grade.values.firstWhere(
        (e) => e.name == json['generalLevel'],
      ),
    );
  }

  @override
  List<Object?> get props => [subjectType, generalLevel];
}
