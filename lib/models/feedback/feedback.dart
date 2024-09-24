import 'package:VetScholar/models/feedback/sentiment.dart';
import 'package:json_annotation/json_annotation.dart';

import 'details.dart';

part 'feedback.g.dart';

@JsonSerializable()
class UserFeedback {
  @JsonKey(name: "sentiment")
  Sentiment sentiment;
  @JsonKey(name: "details")
  Details details;

  UserFeedback(this.sentiment, this.details);

  factory UserFeedback.fromJson(Map<String, dynamic> json) =>
      _$UserFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$UserFeedbackToJson(this);
}
