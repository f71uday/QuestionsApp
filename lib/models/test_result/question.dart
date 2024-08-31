import 'package:json_annotation/json_annotation.dart';

import '../Questions/Topics.dart';
import 'answer.dart';

part 'question.g.dart';

@JsonSerializable()
class Questions {
  String text;
  Answer answer;
  final List<Topic> topics;

  Questions(this.text, this.answer, this.topics);

  factory Questions.fromJson(Map<String, dynamic> json) =>
      _$QuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}