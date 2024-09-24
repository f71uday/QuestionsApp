import 'package:json_annotation/json_annotation.dart';

import 'entity_detail.dart';

part 'details.g.dart';

@JsonSerializable()
class Details {
  @JsonKey(name: "rating")
  String? rating;
  @JsonKey(name: "maxRating")
  String? maxRating;
  @JsonKey(name: "emoji")
  String? emoji;
  @JsonKey(name: "text")
  String text;
  @JsonKey(name: "entityDetail")
  EntityDetail entityDetail;

  Details(
      this.rating, this.maxRating, this.emoji, this.text, this.entityDetail);

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}
