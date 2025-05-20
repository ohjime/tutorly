import 'package:flutter_test/flutter_test.dart';
import 'package:tutorly/core/models/timeslot.dart';

void main() {
  // Helper to create DateTime objects for tests easily
  DateTime dt(
    int year,
    int month,
    int day,
    int hour,
    int minute, [
    int second = 0,
    int millisecond = 0,
  ]) => DateTime(year, month, day, hour, minute, second, millisecond);

  group('TimeSlot', () {
    group('Constructor and Basic Properties', () {
      test('should create a valid TimeSlot', () {
        final timeSlot = TimeSlot(
          start: dt(2023, 1, 1, 9, 0),
          end: dt(2023, 1, 1, 10, 0),
        );
        expect(timeSlot.start, dt(2023, 1, 1, 9, 0));
        expect(timeSlot.end, dt(2023, 1, 1, 10, 0));
        expect(timeSlot.isValid, isTrue);
      });

      test('should throw AssertionError if start is not before end', () {
        expect(
          () =>
              TimeSlot(start: dt(2023, 1, 1, 10, 0), end: dt(2023, 1, 1, 9, 0)),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should throw AssertionError if start equals end', () {
        expect(
          () =>
              TimeSlot(start: dt(2023, 1, 1, 9, 0), end: dt(2023, 1, 1, 9, 0)),
          throwsA(isA<AssertionError>()),
        );
      });

      test('isValid should be true when start is before end', () {
        final timeSlot = TimeSlot(
          start: dt(2023, 1, 1, 8, 0),
          end: dt(2023, 1, 1, 8, 30),
        );
        expect(timeSlot.isValid, isTrue);
      });
    });

    group('overlaps method', () {
      // Base Block: 2023-01-01 10:00 - 12:00
      final baseBlock = TimeSlot(
        start: dt(2023, 1, 1, 10, 0),
        end: dt(2023, 1, 1, 12, 0),
      );

      test('should return true for right overlap', () {
        // Other Block: 2023-01-01 11:00 - 13:00
        final otherBlock = TimeSlot(
          start: dt(2023, 1, 1, 11, 0),
          end: dt(2023, 1, 1, 13, 0),
        );
        expect(baseBlock.overlaps(otherBlock), isTrue);
        expect(otherBlock.overlaps(baseBlock), isTrue);
      });

      test('should return true for left overlap', () {
        // Other Block: 2023-01-01 09:00 - 11:00
        final otherBlock = TimeSlot(
          start: dt(2023, 1, 1, 9, 0),
          end: dt(2023, 1, 1, 11, 0),
        );
        expect(baseBlock.overlaps(otherBlock), isTrue);
        expect(otherBlock.overlaps(baseBlock), isTrue);
      });

      test('should return false for no overlap (other Block after)', () {
        // Other Block: 2023-01-01 13:00 - 14:00
        final otherBlock = TimeSlot(
          start: dt(2023, 1, 1, 13, 0),
          end: dt(2023, 1, 1, 14, 0),
        );
        expect(baseBlock.overlaps(otherBlock), isFalse);
        expect(otherBlock.overlaps(baseBlock), isFalse);
      });

      test('should return false for no overlap (other Block before)', () {
        // Other Block: 2023-01-01 08:00 - 09:00
        final otherBlock = TimeSlot(
          start: dt(2023, 1, 1, 8, 0),
          end: dt(2023, 1, 1, 9, 0),
        );
        expect(baseBlock.overlaps(otherBlock), isFalse);
        expect(otherBlock.overlaps(baseBlock), isFalse);
      });

      test('should return false for no overlap (other Block adjacent, after)', () {
        // Other Block: 2023-01-01 12:00 - 13:00 (base ends at 12:00, other starts at 12:00)
        final otherBlock = TimeSlot(
          start: dt(2023, 1, 1, 12, 0),
          end: dt(2023, 1, 1, 13, 0),
        );
        expect(
          baseBlock.overlaps(otherBlock),
          isFalse,
          reason:
              "Adjacent Blocks should not overlap: base.end is not after other.start",
        );
        expect(
          otherBlock.overlaps(baseBlock),
          isFalse,
          reason:
              "Adjacent Blocks should not overlap: other.end is not after base.start",
        );
      });

      test(
        'should return false for no overlap (other Block adjacent, before)',
        () {
          // Other Block: 2023-01-01 09:00 - 10:00 (other ends at 10:00, base starts at 10:00)
          final otherBlock = TimeSlot(
            start: dt(2023, 1, 1, 9, 0),
            end: dt(2023, 1, 1, 10, 0),
          );
          expect(baseBlock.overlaps(otherBlock), isFalse);
          expect(otherBlock.overlaps(baseBlock), isFalse);
        },
      );

      test(
        'should return true when one Block contains another (base contains other)',
        () {
          // Other Block: 2023-01-01 10:30 - 11:30
          final otherBlock = TimeSlot(
            start: dt(2023, 1, 1, 10, 30),
            end: dt(2023, 1, 1, 11, 30),
          );
          expect(baseBlock.overlaps(otherBlock), isTrue);
          expect(otherBlock.overlaps(baseBlock), isTrue);
        },
      );

      test(
        'should return true when one Block contains another (other contains base)',
        () {
          // Other Block: 2023-01-01 09:00 - 13:00
          final otherBlock = TimeSlot(
            start: dt(2023, 1, 1, 9, 0),
            end: dt(2023, 1, 1, 13, 0),
          );
          expect(baseBlock.overlaps(otherBlock), isTrue);
          expect(otherBlock.overlaps(baseBlock), isTrue);
        },
      );

      test('should return true for identical Blocks', () {
        // Other Block: 2023-01-01 10:00 - 12:00
        final otherBlock = TimeSlot(
          start: dt(2023, 1, 1, 10, 0),
          end: dt(2023, 1, 1, 12, 0),
        );
        expect(baseBlock.overlaps(otherBlock), isTrue);
        expect(otherBlock.overlaps(baseBlock), isTrue);
      });

      test('should handle milliseconds correctly in overlaps', () {
        final s1 = TimeSlot(
          start: dt(2023, 1, 1, 10, 0, 0, 0),
          end: dt(2023, 1, 1, 10, 0, 0, 500),
        );
        final s2 = TimeSlot(
          start: dt(2023, 1, 1, 10, 0, 0, 499),
          end: dt(2023, 1, 1, 10, 0, 0, 600),
        );
        final s3 = TimeSlot(
          start: dt(2023, 1, 1, 10, 0, 0, 500),
          end: dt(2023, 1, 1, 10, 0, 0, 700),
        );

        expect(s1.overlaps(s2), isTrue);
        expect(s2.overlaps(s1), isTrue);
        expect(
          s1.overlaps(s3),
          isFalse,
          reason: "s1.end is not after s3.start due to half-open interval",
        );
        expect(
          s3.overlaps(s1),
          isFalse,
          reason: "s3.end is not after s1.start due to half-open interval",
        );
      });
    });

    group('JSON Serialization/Deserialization', () {
      test('toJson should return correct map with ISO-8601 strings', () {
        final start = dt(2023, 1, 1, 9, 0);
        final end = dt(2023, 1, 1, 17, 30);
        final timeSlot = TimeSlot(start: start, end: end);
        expect(timeSlot.toJson(), {
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'id': null,
          'name': null,
        });
      });

      test('fromJson should create TimeSlot from valid JSON map', () {
        final start = dt(2023, 1, 1, 8, 0);
        final end = dt(2023, 1, 1, 12, 15);
        final jsonMap = <String, dynamic>{
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
        };
        final timeSlot = TimeSlot.fromJson(jsonMap);
        expect(timeSlot.start, start);
        expect(timeSlot.end, end);
      });

      test('fromJson should throw ArgumentError for missing "start" key', () {
        final jsonMap = <String, dynamic>{
          'end': dt(2023, 1, 1, 12, 0).toIso8601String(),
        };
        expect(() => TimeSlot.fromJson(jsonMap), throwsArgumentError);
      });

      test('fromJson should throw ArgumentError for missing "end" key', () {
        final jsonMap = <String, dynamic>{
          'start': dt(2023, 1, 1, 8, 0).toIso8601String(),
        };
        expect(() => TimeSlot.fromJson(jsonMap), throwsArgumentError);
      });

      test(
        'fromJson should throw ArgumentError if "start" is not a string',
        () {
          final jsonMap = <String, dynamic>{
            'start': 123,
            'end': dt(2023, 1, 1, 12, 0).toIso8601String(),
          };
          expect(() => TimeSlot.fromJson(jsonMap), throwsArgumentError);
        },
      );

      test('fromJson should throw ArgumentError if "end" is not a string', () {
        final jsonMap = <String, dynamic>{
          'start': dt(2023, 1, 1, 8, 0).toIso8601String(),
          'end': 456,
        };
        expect(() => TimeSlot.fromJson(jsonMap), throwsArgumentError);
      });

      test(
        'fromJson should throw FormatException for invalid ISO-8601 "start" string',
        () {
          final jsonMap = <String, dynamic>{
            'start': 'invalid-date',
            'end': dt(2023, 1, 1, 12, 0).toIso8601String(),
          };
          expect(
            () => TimeSlot.fromJson(jsonMap),
            throwsA(isA<FormatException>()),
          );
        },
      );

      test(
        'fromJson should throw FormatException for invalid ISO-8601 "end" string',
        () {
          final jsonMap = <String, dynamic>{
            'start': dt(2023, 1, 1, 8, 0).toIso8601String(),
            'end': 'invalid-date',
          };
          expect(
            () => TimeSlot.fromJson(jsonMap),
            throwsA(isA<FormatException>()),
          );
        },
      );

      test(
        'fromJson should throw ArgumentError if start is not before end after parsing',
        () {
          final jsonMap = <String, dynamic>{
            'start': dt(2023, 1, 1, 12, 0).toIso8601String(),
            'end': dt(2023, 1, 1, 10, 0).toIso8601String(),
          };
          expect(() => TimeSlot.fromJson(jsonMap), throwsArgumentError);
        },
      );
    });

    group('Equatable Props', () {
      final start1 = dt(2023, 1, 1, 1, 0);
      final end1 = dt(2023, 1, 1, 2, 0);
      final start2 = dt(2023, 1, 1, 10, 0);
      final end2 = dt(2023, 1, 1, 11, 0);

      test('props should contain start and end DateTime objects', () {
        final timeSlot = TimeSlot(start: start1, end: end1);
        expect(timeSlot.props, [start1, end1]);
      });

      test('stringify should be true', () {
        final timeSlot = TimeSlot(start: start1, end: end1);
        expect(timeSlot.stringify, isTrue);
      });

      test(
        'two TimeSlots with same start and end DateTime objects should be equal',
        () {
          final timeSlot1 = TimeSlot(start: start2, end: end2);
          final timeSlot2 = TimeSlot(start: start2, end: end2);
          expect(timeSlot1, equals(timeSlot2));
          expect(timeSlot1.hashCode, equals(timeSlot2.hashCode));
        },
      );

      test(
        'two TimeSlots with different start DateTime objects should not be equal',
        () {
          final timeSlot1 = TimeSlot(start: start2, end: end2);
          final timeSlot2 = TimeSlot(start: dt(2023, 1, 1, 9, 0), end: end2);
          expect(timeSlot1, isNot(equals(timeSlot2)));
        },
      );

      test(
        'two TimeSlots with different end DateTime objects should not be equal',
        () {
          final timeSlot1 = TimeSlot(start: start2, end: end2);
          final timeSlot2 = TimeSlot(start: start2, end: dt(2023, 1, 1, 12, 0));
          expect(timeSlot1, isNot(equals(timeSlot2)));
        },
      );
    });
  });
}
