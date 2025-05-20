import 'package:flutter_test/flutter_test.dart';
import 'package:tutorly/core/core.dart';

void main() {
  group('Student Tests', () {
    // Create test data
    final Course testCourse1 = Course(
      subjectType: Subject.math,
      generalLevel: Grade.undergraduate,
    );

    final Course testCourse2 = Course(
      subjectType: Subject.physics,
      generalLevel: Grade.twelve,
    );

    test('Student can be instantiated', () {
      final student = Student(
        uid: 'student-123',
        bio: 'Test student bio',
        headline: 'Math student',
        status: StudentStatus.active,
        courses: [testCourse1, testCourse2],
        gradeLevel: Grade.undergraduate,
        educationInstitute: 'Test University',
      );

      expect(student.uid, 'student-123');
      expect(student.bio, 'Test student bio');
      expect(student.headline, 'Math student');
      expect(student.status, StudentStatus.active);
      expect(student.courses.length, 2);
      expect(student.courses[0], testCourse1);
      expect(student.courses[1], testCourse2);
      expect(student.gradeLevel, Grade.undergraduate);
      expect(student.educationInstitute, 'Test University');
    });

    test('Student implements equality correctly', () {
      final student1 = Student(
        uid: 'student-123',
        bio: 'Test student bio',
        headline: 'Math student',
        status: StudentStatus.active,
        courses: [testCourse1, testCourse2],
        gradeLevel: Grade.undergraduate,
        educationInstitute: 'Test University',
      );

      final student2 = Student(
        uid: 'student-123',
        bio: 'Test student bio',
        headline: 'Math student',
        status: StudentStatus.active,
        courses: [testCourse1, testCourse2],
        gradeLevel: Grade.undergraduate,
        educationInstitute: 'Test University',
      );

      final student3 = Student(
        uid: 'student-456',
        bio: 'Test student bio',
        headline: 'Math student',
        status: StudentStatus.active,
        courses: [testCourse1, testCourse2],
        gradeLevel: Grade.undergraduate,
        educationInstitute: 'Test University',
      );

      expect(student1, student2);
      expect(student1, isNot(student3));

      expect(student1.props, [
        'student-123',
        'Test student bio',
        [testCourse1, testCourse2],
        'Math student',
        Grade.undergraduate,
        'Test University',
        StudentStatus.active,
      ]);
    });

    test('Student copyWith works correctly', () {
      final student = Student(
        uid: 'student-123',
        bio: 'Test student bio',
        headline: 'Math student',
        status: StudentStatus.active,
        courses: [testCourse1],
        gradeLevel: Grade.undergraduate,
        educationInstitute: 'Test University',
      );

      final newCourses = [testCourse2];
      final copiedStudent = student.copyWith(
        bio: 'Updated bio',
        courses: newCourses,
      );

      expect(copiedStudent.uid, 'student-123'); // Unchanged
      expect(copiedStudent.bio, 'Updated bio');
      expect(copiedStudent.headline, 'Math student'); // Unchanged
      expect(copiedStudent.status, StudentStatus.active); // Unchanged
      expect(copiedStudent.courses, newCourses);
      expect(copiedStudent.gradeLevel, Grade.undergraduate); // Unchanged
      expect(copiedStudent.educationInstitute, 'Test University'); // Unchanged

      // Original should be unchanged
      expect(student.bio, 'Test student bio');
      expect(student.courses, [testCourse1]);

      // Test partial update
      final copiedStudent2 = student.copyWith(
        bio: 'Another bio update',
        gradeLevel: Grade.graduate,
        status: StudentStatus.inactive,
      );

      expect(copiedStudent2.uid, 'student-123'); // Unchanged
      expect(copiedStudent2.bio, 'Another bio update');
      expect(copiedStudent2.headline, 'Math student'); // Unchanged
      expect(copiedStudent2.status, StudentStatus.inactive);
      expect(copiedStudent2.courses, student.courses); // Unchanged
      expect(copiedStudent2.gradeLevel, Grade.graduate);
      expect(copiedStudent2.educationInstitute, 'Test University'); // Unchanged
    });

    test('Student model with empty courses', () {
      final student = Student(
        uid: 'student-123',
        bio: 'Test student bio',
        headline: 'Math student',
        status: StudentStatus.active,
        courses: [],
        gradeLevel: Grade.undergraduate,
        educationInstitute: 'Test University',
      );

      expect(student.courses, isEmpty);
    });
  });
}
