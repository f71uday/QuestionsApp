import 'package:VetScholar/models/link.dart';
import 'package:VetScholar/models/utils/DurationConverter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Remark.dart';

part 'test_result.g.dart';

@JsonSerializable()
class TestResult {
  final double percentage;
  final Remark remark;
  final DateTime createdAt;
  @DurationConverter()
  final Duration timeTaken;
  final String testName;
  final int totalQuestions;
  final int correctAnswers;
  @JsonKey(name: '_links')
  final Map<String, Link> links;

  TestResult(this.percentage, this.remark, this.createdAt, this.timeTaken,
      this.testName, this.totalQuestions, this.correctAnswers, this.links);

  factory TestResult.fromJson(Map<String, dynamic> json) =>
      _$TestResultFromJson(json);

  Map<String, dynamic> toJson() => _$TestResultToJson(this);
}
