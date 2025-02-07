import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(createToJson: false)
class Category {
  Category({
    required this.name,
    required this.rating,
    required this.compoundCode,
    required this.userRatingsTotal,
    required this.vicinity,
    required this.type,
    required this.photoUrls,
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.editorialSummary,
    required this.distance,
    required this.walkingTime,
  });

  final String? name;
  final double? rating;

  @JsonKey(name: 'compound_code')
  final String? compoundCode;

  @JsonKey(name: 'user_ratings_total')
  final int? userRatingsTotal;
  final String? vicinity;
  @JsonKey(name: 'place_type')
  final List<String>? type;
  @JsonKey(name: 'photo_urls')
  final List<String>? photoUrls;

  @JsonKey(name: 'place_id')
  final String? placeId;
  final double? latitude;
  final double? longitude;

  @JsonKey(name: 'editorial_summary')
  final dynamic editorialSummary;
  final int? distance;

  @JsonKey(name: 'walking_time')
  final int? walkingTime;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}


List <Category> get dummyCategoryList{
  return List.generate(6, (index){
    return Category(
      name: 'Category $index',
      rating: 4.5,
      compoundCode: 'CP123456',
      userRatingsTotal: 1000,
      vicinity: '123 Main St',
      type: [],
      photoUrls: ['https://example.com/photo1.jpg', 'https://example.com/photo2.jpg'],
      placeId: '1234567890',
      latitude: 37.7749,
      longitude: -122.4194,
      editorialSummary: 'This is a sample restaurant',
      distance: 1500,
      walkingTime: 30,
    );
  });
}