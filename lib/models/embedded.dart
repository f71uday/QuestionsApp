import 'package:VetScholar/models/test_result.dart';
import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:json_annotation/json_annotation.dart';

part 'embedded.g.dart';

@JsonSerializable(explicitToJson: true)
class Embedded {
  @JsonKey(name: 'testResponses')
   List<TestResult>? testResponses;
  @JsonKey(name: "questionResponses")
  List<QuestionResponses>? questionResponses;
  @JsonKey(name: 'questionBookmarks')
  List<QuestionResponses>? bookmarkedQuestions;


  Embedded(
      this.testResponses, this.questionResponses, this.bookmarkedQuestions);

  factory Embedded.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddedToJson(this);
}
