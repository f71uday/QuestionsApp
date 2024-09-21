import 'package:VetScholar/models/test_result/result.dart';
import 'package:json_annotation/json_annotation.dart';
import 'question.dart';
part 'question_responses.g.dart';
@JsonSerializable(explicitToJson: true)
class QuestionResponses{
    @JsonKey(name: "question")
    Questions question;
    String? userAnswer;
    Result result;

    QuestionResponses(this.question, this.userAnswer, this.result);


  factory QuestionResponses.fromJson(Map<String, dynamic> json) =>
        _$QuestionResponsesFromJson(json);

    Map<String, dynamic> toJson() => _$QuestionResponsesToJson(this);
}
