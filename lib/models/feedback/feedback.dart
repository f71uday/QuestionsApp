import 'package:VetScholar/models/feedback/sentiment.dart';
import 'package:json_annotation/json_annotation.dart';

import 'details.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  @JsonKey(name: "sentiment")
  Sentiment sentiment;
  @JsonKey(name: "details")
  Details details;

  Feedback(this.sentiment, this.details);

  factory Feedback.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackToJson(this);
}
