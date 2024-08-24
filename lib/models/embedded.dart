import 'package:VetScholar/models/test_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'embedded.g.dart';

@JsonSerializable(explicitToJson: true)
class Embedded {
  @JsonKey(name: 'testResponses')
  final List<TestResult> entities;

  Embedded(this.entities);

  factory Embedded.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddedToJson(this);
}
