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

Map<String, dynamic> _$UserItineraryToJson(UserItinerary instance) =>
    <String, dynamic>{
      'userIteneries': instance.userIteneries,
      'sharedIteneries': instance.sharedIteneries,
    };

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

Map<String, dynamic> _$IteneryToJson(Itenery instance) => <String, dynamic>{
      'itinerary': instance.itinerary,
      'canView': instance.canView,
      'canEdit': instance.canEdit,
      'placesCount': instance.placesCount,
    };

Can _$CanFromJson(Map<String, dynamic> json) => Can(
      id: (json['id'] as num?)?.toInt(),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CanToJson(Can instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'image': instance.image,
    };

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
      location: json['location'] as String?,
      placesCount: (json['placesCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ItineraryToJson(Itinerary instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'type': instance.type,
      'image': instance.image,
      'can_view': instance.canView,
      'can_edit': instance.canEdit,
      'is_deleted': instance.isDeleted,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'have_access': instance.haveAccess,
      'shareUrl': instance.shareUrl,
      'location': instance.location,
      'placesCount': instance.placesCount,
    };
