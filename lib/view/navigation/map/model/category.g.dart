// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      name: json['name'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      compoundCode: json['compound_code'] as String?,
      userRatingsTotal: (json['user_ratings_total'] as num?)?.toInt(),
      vicinity: json['vicinity'] as String?,
      type: (json['type'] as List<dynamic>?)?.map((e) => e as String).toList(),
      photoUrls: (json['photo_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      placeId: json['place_id'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      editorialSummary: json['editorial_summary'],
      distance: (json['distance'] as num?)?.toInt(),
      walkingTime: (json['walking_time'] as num?)?.toInt(),
    );
