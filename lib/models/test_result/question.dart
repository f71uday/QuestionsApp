import 'package:json_annotation/json_annotation.dart';

import '../Questions/Topics.dart';
import 'answer.dart';

part 'question.g.dart';

@JsonSerializable()
class Questions {
  int id;
  String text;
  Answer answer;
  @JsonKey(name: 'bookmarked')
  bool? isBookMarked;
  final List<Topic> topics;

  Questions(this.text, this.answer, this.topics, this.isBookMarked, this.id);

  factory Questions.fromJson(Map<String, dynamic> json) =>
      _$QuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}