import 'package:fernweh/utils/common/common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'itinerary_places.g.dart';

@JsonSerializable(createToJson: false)
class ItineraryPlaces {
  ItineraryPlaces({
    required this.id,
    required this.userId,
    required this.addedBy,
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
    required this.ownerImage,
  });

  final int? id;
  final int? userId;
  @JsonKey(name: 'added_by')
  final String? addedBy;
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
  @JsonKey(name: 'owner_image')
  final String? ownerImage;

  factory ItineraryPlaces.fromJson(Map<String, dynamic> json) =>
      _$ItineraryPlacesFromJson(json);
  String get addedByName {
    if (addedBy == null || addedBy!.isEmpty) {
      return '';
    }

    final parts = addedBy?.split(' ');

    final firstName = parts!.isNotEmpty ? parts.first : '';

    final lastNameInitial = (parts.length > 1 && parts.last.isNotEmpty)
        ? parts.last[0].toUpperCase()
        : '';
    return lastNameInitial.isNotEmpty ? '$firstName $lastNameInitial' : firstName;
  }
  String? get ownerImageUrl {
    if (ownerImage != null) {

      return "${Common.baseUrl}/public/$ownerImage";
    }
    return null;
  }

}
