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
  final String? type;
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
