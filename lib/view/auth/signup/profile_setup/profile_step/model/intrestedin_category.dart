import 'package:json_annotation/json_annotation.dart';

part 'intrestedin_category.g.dart';

@JsonSerializable(createToJson: false)
class IntrestedInCategory {
  IntrestedInCategory({
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

  factory IntrestedInCategory.fromJson(Map<String, dynamic> json) =>
      _$IntrestedInCategoryFromJson(json);

  static List<IntrestedInCategory> get dummyCategory {
    return List.generate(
        5,
        (index) => IntrestedInCategory(
            id: null,
            type: '',
            name: 'dummy',
            image:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQABqQIdskCD9BK0I81EbVfV9tTz320XvJ35A&s',
            isDeleted: null,
            createdAt: null,
            updatedAt: null));
  }
}
