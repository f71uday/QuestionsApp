import 'package:json_annotation/json_annotation.dart';

class DurationConverter implements JsonConverter<Duration, String> {
  const DurationConverter();

  @override
  Duration fromJson(String json) {
    final regex = RegExp(r'^P(T(?:(-?\d+)H)?(?:(-?\d+)M)?(?:(-?\d+(?:\.\d+)?)S)?)$');
    final match = regex.firstMatch(json);

    if (match == null) {
      throw FormatException('Invalid ISO-8601 duration format', json);
    }

    final hours = int.tryParse(match.group(2) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(3) ?? '0') ?? 0;
    final secondsString = match.group(4) ?? '0';
    final seconds = double.tryParse(secondsString) ?? 0.0;

    // Convert fractional seconds to microseconds and round to nearest microsecond
    final duration = Duration(
      hours: hours,
      minutes: minutes,
      microseconds: (seconds * 1e6).round(),
    );

    return duration;
  }

  @override
  String toJson(Duration object) {
    if (object == Duration.zero) {
      return 'PT0S'; // Handle zero duration case
    }

    final hours = object.inHours;
    final minutes = object.inMinutes % 60;
    final seconds = object.inSeconds % 60;
    final microseconds = object.inMicroseconds % 1e6;

    final buffer = StringBuffer('PT');
    if (hours != 0) buffer.write('${hours}H');
    if (minutes != 0) buffer.write('${minutes}M');

    if (microseconds != 0) {
      final fractionalSeconds = (seconds + microseconds / 1e6).toStringAsFixed(6);
      buffer.write('${fractionalSeconds}S');
    } else if (seconds != 0 || buffer.length == 2) {
      buffer.write('${seconds}S');
    }

    return buffer.toString();
  }
}
