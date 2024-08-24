import 'package:json_annotation/json_annotation.dart';

part 'QuestionResponse.g.dart';

@JsonSerializable()
class QuestionResponse {
  final int questionId;
  final String answer;
  final DateTime startedAt;
  final DateTime endedAt;

  QuestionResponse(this.questionId, this.answer, this.startedAt, this.endedAt);

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionResponseToJson(this);
}

@JsonSerializable()
class TestResponse {
  final List<QuestionResponse> questionResponses;
  final DateTime startedAt;
  final DateTime endedAt;


  TestResponse(this.questionResponses, this.startedAt, this.endedAt);

  factory TestResponse.fromJson(Map<String, dynamic> json) =>
      _$TestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TestResponseToJson(this);
}
