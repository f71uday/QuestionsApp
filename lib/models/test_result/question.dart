import 'package:json_annotation/json_annotation.dart';

import 'answer.dart';

part 'question.g.dart';

@JsonSerializable()
class Questions {
  String text;
  Answer answer;

  Questions(this.text, this.answer);

  factory Questions.fromJson(Map<String, dynamic> json) =>
      _$QuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}