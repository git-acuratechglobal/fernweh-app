import 'package:json_annotation/json_annotation.dart';

part 'itinerary_places.g.dart';

@JsonSerializable(createToJson: false)
class ItineraryPlaces {
  ItineraryPlaces({
    required this.id,
    required this.userId,
    required this.intineraryListId,
    required this.locationId,
    required this.type,
    required this.isFavorite,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.rating,
    required this.formattedAddress,
    required this.photo,
    required this.vicinity,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.walkingTime,
    required this.placeTypes,
  });

  final int? id;
  final int? userId;
  final int? intineraryListId;
  final String? locationId;
  final int? type;

  @JsonKey(name: 'is_favorite')
  final int? isFavorite;

  @JsonKey(name: 'is_deleted')
  final int? isDeleted;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final String? name;
  final double? rating;

  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;
  final String? photo;
  final dynamic vicinity;
  final double? latitude;
  final double? longitude;
  final int? distance;

  @JsonKey(name: 'walking_time')
  final int? walkingTime;
  @JsonKey(name: 'place_types')
  final String? placeTypes;

  factory ItineraryPlaces.fromJson(Map<String, dynamic> json) =>
      _$ItineraryPlacesFromJson(json);
}
