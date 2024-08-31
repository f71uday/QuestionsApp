import 'package:json_annotation/json_annotation.dart';

part 'Topics.g.dart';

@JsonSerializable()
class Topic {
  final String name;

  Topic({required this.name});

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
