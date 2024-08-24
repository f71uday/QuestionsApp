import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable()
class Page {
  final int size;
  final int totalElements;
  final int totalPages;
  final int number;

  Page(this.size, this.totalElements, this.totalPages, this.number);

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}
