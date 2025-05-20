import 'package:flutter_test/flutter_test.dart';
import 'package:tutorly/core/core.dart';

void main() {
  group('Grade Tests', () {
    test('Grade enum values are correct', () {
      expect(Grade.values.length, 6);
      expect(Grade.values.contains(Grade.unknown), true);
      expect(Grade.values.contains(Grade.ten), true);
      expect(Grade.values.contains(Grade.eleven), true);
      expect(Grade.values.contains(Grade.twelve), true);
      expect(Grade.values.contains(Grade.undergraduate), true);
      expect(Grade.values.contains(Grade.graduate), true);
    });

    test('Grade enum values have correct index order', () {
      expect(Grade.unknown.index, 0);
      expect(Grade.ten.index, 1);
      expect(Grade.eleven.index, 2);
      expect(Grade.twelve.index, 3);
      expect(Grade.undergraduate.index, 4);
      expect(Grade.graduate.index, 5);
    });

    test('Less than operator works correctly', () {
      expect(Grade.ten < Grade.eleven, true);
      expect(Grade.twelve < Grade.ten, false);
      expect(Grade.undergraduate < Grade.graduate, true);
      expect(Grade.graduate < Grade.unknown, false);
    });

    test('Greater than operator works correctly', () {
      expect(Grade.eleven > Grade.ten, true);
      expect(Grade.ten > Grade.twelve, false);
      expect(Grade.graduate > Grade.undergraduate, true);
      expect(Grade.unknown > Grade.graduate, false);
    });

    test('Less than or equal operator works correctly', () {
      expect(Grade.ten <= Grade.eleven, true);
      expect(Grade.ten <= Grade.ten, true);
      expect(Grade.twelve <= Grade.ten, false);
    });

    test('Greater than or equal operator works correctly', () {
      expect(Grade.eleven >= Grade.ten, true);
      expect(Grade.eleven >= Grade.eleven, true);
      expect(Grade.ten >= Grade.twelve, false);
    });
  });
}
