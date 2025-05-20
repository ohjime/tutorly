import 'package:flutter_test/flutter_test.dart';
import 'package:tutorly/core/core.dart';

void main() {
  group('Tutor Tests', () {
    // Create test data
    final Course testCourse1 = Course(
      subjectType: Subject.math,
      generalLevel: Grade.undergraduate,
    );

    final Course testCourse2 = Course(
      subjectType: Subject.physics,
      generalLevel: Grade.twelve,
    );

    final AcademicCredential testCredential = AcademicCredential(
      institution: 'Test University',
      level: AcademicCredentialLevel.bachelor,
      fieldOfStudy: 'Mathematics',
      dateIssued: DateTime(2020, 5, 15),
      imageUrl: 'https://example.com/diploma.jpg',
      focus: '',
    );

    test('Tutor can be instantiated', () {
      final tutor = Tutor(
        uid: 'tutor-123',
        bio: 'Test tutor bio',
        headline: 'Test headline', // Added headline
        courses: [testCourse1, testCourse2],
        tutorStatus: TutorStatus.active,
        academicCredentials: [testCredential],
      );

      expect(tutor.uid, 'tutor-123');
      expect(tutor.bio, 'Test tutor bio');
      expect(tutor.headline, 'Test headline'); // Added expectation for headline
      expect(tutor.courses.length, 2);
      expect(tutor.courses[0], testCourse1);
      expect(tutor.courses[1], testCourse2);
      expect(tutor.tutorStatus, TutorStatus.active);
      expect(tutor.academicCredentials.length, 1);
      expect(tutor.academicCredentials[0], testCredential);
    });

    test('Tutor implements equality correctly', () {
      final tutor1 = Tutor(
        uid: 'tutor-123',
        bio: 'Test tutor bio',
        headline: 'Test headline', // Added headline
        courses: [testCourse1, testCourse2],
        tutorStatus: TutorStatus.active,
        academicCredentials: [testCredential],
      );

      final tutor2 = Tutor(
        uid: 'tutor-123',
        bio: 'Test tutor bio',
        headline: 'Test headline', // Added headline
        courses: [testCourse1, testCourse2],
        tutorStatus: TutorStatus.active,
        academicCredentials: [testCredential],
      );

      final tutor3 = Tutor(
        uid: 'tutor-456',
        bio: 'Test tutor bio',
        headline: 'Another headline', // Added different headline for tutor3
        courses: [testCourse1, testCourse2],
        tutorStatus: TutorStatus.active,
        academicCredentials: [testCredential],
      );

      expect(tutor1, tutor2);
      expect(tutor1, isNot(tutor3));

      expect(tutor1.props, [
        'tutor-123',
        'Test tutor bio',
        [testCourse1, testCourse2],
        'Test headline', // Added headline to props
        TutorStatus.active,
        [testCredential],
      ]);
    });

    test('Tutor copyWith works correctly', () {
      final tutor = Tutor(
        uid: 'tutor-123',
        bio: 'Test tutor bio',
        headline: 'Test headline', // Added headline
        courses: [testCourse1],
        tutorStatus: TutorStatus.active,
        academicCredentials: [testCredential],
      );

      final newCourses = [testCourse1, testCourse2];
      final copiedTutor = tutor.copyWith(
        bio: 'Updated bio',
        courses: newCourses,
        tutorStatus: TutorStatus.inactive,
        headline: 'Updated headline', // Added headline to copyWith
      );

      expect(copiedTutor.uid, 'tutor-123'); // Unchanged
      expect(copiedTutor.bio, 'Updated bio');
      expect(
        copiedTutor.headline,
        'Updated headline',
      ); // Added expectation for copied headline
      expect(copiedTutor.courses, newCourses);
      expect(copiedTutor.tutorStatus, TutorStatus.inactive);
      expect(
        copiedTutor.academicCredentials,
        tutor.academicCredentials,
      ); // Unchanged

      // Original should be unchanged
      expect(tutor.bio, 'Test tutor bio');
      expect(tutor.headline, 'Test headline'); // Unchanged
      expect(tutor.courses, [testCourse1]);
      expect(tutor.tutorStatus, TutorStatus.active);

      // Test partial update
      final copiedTutor2 = tutor.copyWith(bio: 'Another bio update');

      expect(copiedTutor2.uid, 'tutor-123'); // Unchanged
      expect(copiedTutor2.bio, 'Another bio update');
      expect(copiedTutor2.headline, tutor.headline); // Unchanged
      expect(copiedTutor2.courses, tutor.courses); // Unchanged
      expect(copiedTutor2.tutorStatus, tutor.tutorStatus); // Unchanged
    });

    test('Tutor model with empty lists', () {
      final tutor = Tutor(
        uid: 'tutor-123',
        bio: 'Test tutor bio',
        headline: '', // Added headline (empty)
        courses: [],
        tutorStatus: TutorStatus.active,
        academicCredentials: [],
      );

      expect(tutor.courses, isEmpty);
      expect(tutor.academicCredentials, isEmpty);
      expect(tutor.headline, ''); // Added expectation for headline
    });
  });
}
