import 'package:flutter_test/flutter_test.dart';
import 'package:tutorly/core/core.dart';

void main() {
  group('Course Tests', () {
    test('Course can be instantiated', () {
      final course = Course(
        subjectType: Subject.math,
        generalLevel: Grade.undergraduate,
      );
      expect(course.subjectType, Subject.math);
      expect(course.generalLevel, Grade.undergraduate);
    });

    test('Course implements equality correctly', () {
      final course1 = Course(
        subjectType: Subject.math,
        generalLevel: Grade.undergraduate,
      );

      final course2 = Course(
        subjectType: Subject.math,
        generalLevel: Grade.undergraduate,
      );

      final course3 = Course(
        subjectType: Subject.physics,
        generalLevel: Grade.undergraduate,
      );

      final course4 = Course(
        subjectType: Subject.math,
        generalLevel: Grade.twelve,
      );

      expect(course1, course2);
      expect(course1, isNot(course3));
      expect(course1, isNot(course4));

      expect(course1.props, [Subject.math, Grade.undergraduate]);
    });

    test('Course copyWith works correctly', () {
      final course = Course(
        subjectType: Subject.math,
        generalLevel: Grade.undergraduate,
      );

      final copiedCourse = course.copyWith();

      expect(copiedCourse.subjectType, Subject.math); // Unchanged
      expect(copiedCourse.generalLevel, Grade.undergraduate); // Unchanged

      final copiedCourse2 = course.copyWith(
        subjectType: Subject.physics,
        generalLevel: Grade.graduate,
      );

      expect(copiedCourse2.subjectType, Subject.physics);
      expect(copiedCourse2.generalLevel, Grade.graduate);

      // Original should be unchanged
      expect(course.subjectType, Subject.math);
      expect(course.generalLevel, Grade.undergraduate);
    });
  });
}
