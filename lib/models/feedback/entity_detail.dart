import 'package:json_annotation/json_annotation.dart';

import 'entity_type.dart';

part 'entity_detail.g.dart';

@JsonSerializable()
class EntityDetail {
  @JsonKey(name: "entityType")
  EntityType entityType;
  @JsonKey(name: "id")
  int id;

  EntityDetail(this.entityType, this.id);

  factory EntityDetail.fromJson(Map<String, dynamic> json) =>
      _$EntityDetailFromJson(json);

  Map<String, dynamic> toJson() => _$EntityDetailToJson(this);
}
