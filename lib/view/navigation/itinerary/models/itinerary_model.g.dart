// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserItinerary _$UserItineraryFromJson(Map<String, dynamic> json) =>
    UserItinerary(
      userIteneries: (json['userIteneries'] as List<dynamic>?)
          ?.map((e) => Itenery.fromJson(e as Map<String, dynamic>))
          .toList(),
      sharedIteneries: (json['sharedIteneries'] as List<dynamic>?)
          ?.map((e) => Itenery.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Itenery _$IteneryFromJson(Map<String, dynamic> json) => Itenery(
      itinerary: json['itinerary'] == null
          ? null
          : Itinerary.fromJson(json['itinerary'] as Map<String, dynamic>),
      canView: (json['canView'] as List<dynamic>?)
          ?.map((e) => Can.fromJson(e as Map<String, dynamic>))
          .toList(),
      canEdit: (json['canEdit'] as List<dynamic>?)
          ?.map((e) => Can.fromJson(e as Map<String, dynamic>))
          .toList(),
      placesCount: (json['placesCount'] as num?)?.toInt(),
    );

Can _$CanFromJson(Map<String, dynamic> json) => Can(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
    );

Itinerary _$ItineraryFromJson(Map<String, dynamic> json) => Itinerary(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      canView: json['can_view'] as String?,
      canEdit: json['can_edit'] as String?,
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      haveAccess: json['have_access'] as String?,
      shareUrl: json['shareUrl'] as String?,
    );
