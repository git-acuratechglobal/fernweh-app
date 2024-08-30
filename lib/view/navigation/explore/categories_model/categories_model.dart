import 'package:json_annotation/json_annotation.dart';

part 'categories_model.g.dart';

@JsonSerializable(createToJson: false)
class Categories {
  Categories({
    required this.id,
    required this.type,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? type;
  final String? name;
  final String? image;

  @JsonKey(name: 'is_deleted')
  final int? isDeleted;

  @JsonKey(name: 'created_at')
  final dynamic createdAt;

  @JsonKey(name: 'updated_at')
  final dynamic updatedAt;

  factory Categories.fromJson(Map<String, dynamic> json) => _$CategoriesFromJson(json);

}
