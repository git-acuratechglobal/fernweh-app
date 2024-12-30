// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_places.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItineraryPlaces _$ItineraryPlacesFromJson(Map<String, dynamic> json) =>
    ItineraryPlaces(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      addedBy: json['added_by'] as String?,
      intineraryListId: (json['intineraryListId'] as num?)?.toInt(),
      locationId: json['locationId'] as String?,
      type: (json['type'] as num?)?.toInt(),
      isFavorite: (json['is_favorite'] as num?)?.toInt(),
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      name: json['name'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      formattedAddress: json['formatted_address'] as String?,
      photo: json['photo'] as String?,
      vicinity: json['vicinity'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toInt(),
      walkingTime: (json['walking_time'] as num?)?.toInt(),
      placeTypes: json['place_types'] as String?,
    );
