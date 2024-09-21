import 'package:VetScholar/models/embedded.dart';
import 'package:VetScholar/models/link.dart';
import 'package:VetScholar/models/page.dart';
import 'package:VetScholar/models/test_result/question_responses.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paged_response.g.dart';

@JsonSerializable()
class PagedResponse {
  @JsonKey(name: "_embedded")
  final Embedded? embedded;
  @JsonKey(name: "questionResponses")
  List<QuestionResponses>? questionResponses;

  @JsonKey(name: '_links')
  final Map<String, Link>? links;

  final Page? page;

  PagedResponse(this.embedded, this.questionResponses,
      this.links, this.page);

  factory PagedResponse.fromJson(Map<String, dynamic> json) =>
      _$PagedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PagedResponseToJson(this);
}
