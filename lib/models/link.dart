
import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

@JsonSerializable()
class Link {
  final String href;

  Link(this.href);

  factory Link.fromJson(Map<String, dynamic> json) =>
      _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);
}