import 'package:flutter_test/flutter_test.dart';
import 'package:tutorly/core/core.dart';

void main() {
  group('Subject Tests', () {
    test('Subject enum values are correct', () {
      expect(Subject.values.length, 7);
      expect(Subject.values.contains(Subject.math), true);
      expect(Subject.values.contains(Subject.science), true);
      expect(Subject.values.contains(Subject.english), true);
      expect(Subject.values.contains(Subject.chemistry), true);
      expect(Subject.values.contains(Subject.physics), true);
      expect(Subject.values.contains(Subject.biology), true);
      expect(Subject.values.contains(Subject.socialStudies), true);
    });

    test('Subject enum values have correct index order', () {
      expect(Subject.math.index, 0);
      expect(Subject.science.index, 1);
      expect(Subject.english.index, 2);
      expect(Subject.chemistry.index, 3);
      expect(Subject.physics.index, 4);
      expect(Subject.biology.index, 5);
      expect(Subject.socialStudies.index, 6);
    });
  });
}
