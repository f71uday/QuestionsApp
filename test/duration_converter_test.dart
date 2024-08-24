import 'package:VetScholar/models/utils/DurationConverter.dart';
import 'package:test/test.dart';

void main() {
  const durationConverter = DurationConverter();

  group('DurationConverter', () {
    test('fromJson should parse ISO-8601 duration string correctly', () {
      // Test cases
      final testCases = {
        'PT1H30M': Duration(hours: 1, minutes: 30),
        'PT2H': Duration(hours: 2),
        'PT45M': Duration(minutes: 45),
        'PT30M20S': Duration(minutes: 30, seconds: 20),
        'PT10S': Duration(seconds: 10),
        'PT0S': Duration.zero,
        'PT-0.000005S': Duration(microseconds: -5),
        'PT1.000005S': Duration(seconds: 1, microseconds: 5),
        'PT1H30M0.000005S': Duration(hours: 1, minutes: 30, microseconds: 5),
      };

      testCases.forEach((input, expected) {
        expect(durationConverter.fromJson(input), equals(expected));
      });
    });

    test('fromJson should throw FormatException on invalid input', () {
      // Invalid input strings
      final invalidInputs = [
        '1H30M',
        'PT1M30H', // Invalid order
        'PT1X',    // Invalid character
        '',
        'P1D'      // Days are not supported by Duration
      ];

      for (var input in invalidInputs) {
        expect(() => durationConverter.fromJson(input), throwsFormatException);
      }
    });

    test('toJson should convert Duration to ISO-8601 duration string', () {
      // Test cases
      final testCases = {
        Duration(hours: 1, minutes: 30): 'PT1H30M',
        Duration(hours: 2): 'PT2H',
        Duration(minutes: 45): 'PT45M',
        Duration(minutes: 30, seconds: 20): 'PT30M20S',
        Duration(seconds: 10): 'PT10S',
        Duration.zero: 'PT0S',
      };

      testCases.forEach((input, expected) {
        expect(durationConverter.toJson(input), equals(expected));
      });
    });
  });
}
