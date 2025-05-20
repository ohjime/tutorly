import 'package:flutter_test/flutter_test.dart';
import 'package:tutorly/core/core.dart';

void main() {
  group('AcademicCredentialLevel Tests', () {
    test('AcademicCredentialLevel enum values are correct', () {
      expect(AcademicCredentialLevel.values.length, 6);
      expect(
        AcademicCredentialLevel.values.contains(
          AcademicCredentialLevel.highschool,
        ),
        true,
      );
      expect(
        AcademicCredentialLevel.values.contains(
          AcademicCredentialLevel.certificate,
        ),
        true,
      );
      expect(
        AcademicCredentialLevel.values.contains(
          AcademicCredentialLevel.diploma,
        ),
        true,
      );
      expect(
        AcademicCredentialLevel.values.contains(
          AcademicCredentialLevel.bachelor,
        ),
        true,
      );
      expect(
        AcademicCredentialLevel.values.contains(
          AcademicCredentialLevel.masters,
        ),
        true,
      );
      expect(
        AcademicCredentialLevel.values.contains(
          AcademicCredentialLevel.doctorate,
        ),
        true,
      );
    });

    test('AcademicCredentialLevel enum values have correct index order', () {
      expect(AcademicCredentialLevel.highschool.index, 0);
      expect(AcademicCredentialLevel.certificate.index, 1);
      expect(AcademicCredentialLevel.diploma.index, 2);
      expect(AcademicCredentialLevel.bachelor.index, 3);
      expect(AcademicCredentialLevel.masters.index, 4);
      expect(AcademicCredentialLevel.doctorate.index, 5);
    });

    test('Less than operator works correctly', () {
      expect(
        AcademicCredentialLevel.highschool <
            AcademicCredentialLevel.certificate,
        true,
      );
      expect(
        AcademicCredentialLevel.certificate < AcademicCredentialLevel.diploma,
        true,
      );
      expect(
        AcademicCredentialLevel.diploma < AcademicCredentialLevel.bachelor,
        true,
      );
      expect(
        AcademicCredentialLevel.bachelor < AcademicCredentialLevel.masters,
        true,
      );
      expect(
        AcademicCredentialLevel.masters < AcademicCredentialLevel.doctorate,
        true,
      );

      expect(
        AcademicCredentialLevel.doctorate < AcademicCredentialLevel.highschool,
        false,
      );
      expect(
        AcademicCredentialLevel.bachelor < AcademicCredentialLevel.diploma,
        false,
      );
      expect(
        AcademicCredentialLevel.masters < AcademicCredentialLevel.masters,
        false,
      );
    });

    test('Greater than operator works correctly', () {
      expect(
        AcademicCredentialLevel.certificate >
            AcademicCredentialLevel.highschool,
        true,
      );
      expect(
        AcademicCredentialLevel.diploma > AcademicCredentialLevel.certificate,
        true,
      );
      expect(
        AcademicCredentialLevel.bachelor > AcademicCredentialLevel.diploma,
        true,
      );
      expect(
        AcademicCredentialLevel.masters > AcademicCredentialLevel.bachelor,
        true,
      );
      expect(
        AcademicCredentialLevel.doctorate > AcademicCredentialLevel.masters,
        true,
      );

      expect(
        AcademicCredentialLevel.highschool > AcademicCredentialLevel.doctorate,
        false,
      );
      expect(
        AcademicCredentialLevel.diploma > AcademicCredentialLevel.bachelor,
        false,
      );
      expect(
        AcademicCredentialLevel.masters > AcademicCredentialLevel.masters,
        false,
      );
    });

    test('Less than or equal operator works correctly', () {
      expect(
        AcademicCredentialLevel.highschool <=
            AcademicCredentialLevel.certificate,
        true,
      );
      expect(
        AcademicCredentialLevel.certificate <=
            AcademicCredentialLevel.certificate,
        true,
      );
      expect(
        AcademicCredentialLevel.doctorate <= AcademicCredentialLevel.highschool,
        false,
      );
    });

    test('Greater than or equal operator works correctly', () {
      expect(
        AcademicCredentialLevel.certificate >=
            AcademicCredentialLevel.highschool,
        true,
      );
      expect(
        AcademicCredentialLevel.certificate >=
            AcademicCredentialLevel.certificate,
        true,
      );
      expect(
        AcademicCredentialLevel.highschool >= AcademicCredentialLevel.doctorate,
        false,
      );
    });
  });

  group('AcademicCredential Tests', () {
    final DateTime testDate = DateTime(2020, 5, 15);

    test('AcademicCredential can be instantiated', () {
      final credential = AcademicCredential(
        institution: 'University of Test',
        level: AcademicCredentialLevel.bachelor,
        fieldOfStudy: 'Computer Science',
        dateIssued: testDate,
        imageUrl: 'https://example.com/diploma.jpg',
        focus: '',
      );

      expect(credential.institution, 'University of Test');
      expect(credential.level, AcademicCredentialLevel.bachelor);
      expect(credential.fieldOfStudy, 'Computer Science');
      expect(credential.focus, '');
      expect(credential.dateIssued, testDate);
      expect(credential.imageUrl, 'https://example.com/diploma.jpg');
    });

    test('AcademicCredential can be instantiated with custom focus', () {
      final credential = AcademicCredential(
        institution: 'University of Test',
        level: AcademicCredentialLevel.bachelor,
        fieldOfStudy: 'Computer Science',
        focus: 'Artificial Intelligence',
        dateIssued: testDate,
        imageUrl: 'https://example.com/diploma.jpg',
      );

      expect(credential.focus, 'Artificial Intelligence');
    });

    test('AcademicCredential implements equality correctly', () {
      final credential1 = AcademicCredential(
        institution: 'University of Test',
        level: AcademicCredentialLevel.bachelor,
        fieldOfStudy: 'Computer Science',
        dateIssued: testDate,
        imageUrl: 'https://example.com/diploma.jpg',
        focus: '',
      );

      final credential2 = AcademicCredential(
        institution: 'University of Test',
        level: AcademicCredentialLevel.bachelor,
        fieldOfStudy: 'Computer Science',
        dateIssued: testDate,
        imageUrl: 'https://example.com/diploma.jpg',
        focus: '',
      );

      final credential3 = AcademicCredential(
        institution: 'Different University',
        level: AcademicCredentialLevel.bachelor,
        fieldOfStudy: 'Computer Science',
        dateIssued: testDate,
        imageUrl: 'https://example.com/diploma.jpg',
        focus: '',
      );

      expect(credential1, credential2);
      expect(credential1, isNot(credential3));

      expect(credential1.props, [
        'University of Test',
        AcademicCredentialLevel.bachelor,
        'Computer Science',
        '',
        testDate,
        'https://example.com/diploma.jpg',
      ]);
    });

    test('AcademicCredential copyWith works correctly', () {
      final credential = AcademicCredential(
        institution: 'University of Test',
        level: AcademicCredentialLevel.bachelor,
        fieldOfStudy: 'Computer Science',
        dateIssued: testDate,
        imageUrl: 'https://example.com/diploma.jpg',
        focus: '',
      );

      final newDate = DateTime(2022, 6, 20);
      final copiedCredential = credential.copyWith(
        institution: 'New University',
        dateIssued: newDate,
      );

      expect(copiedCredential.institution, 'New University');
      expect(
        copiedCredential.level,
        AcademicCredentialLevel.bachelor,
      ); // Unchanged
      expect(copiedCredential.fieldOfStudy, 'Computer Science'); // Unchanged
      expect(copiedCredential.dateIssued, newDate);
      expect(
        copiedCredential.imageUrl,
        'https://example.com/diploma.jpg',
      ); // Unchanged

      // Original should be unchanged
      expect(credential.institution, 'University of Test');
      expect(credential.dateIssued, testDate);
    });
  });
}
