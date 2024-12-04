// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      intineraryListId: (json['intineraryListId'] as num?)?.toInt(),
      location: json['location'] as String?,
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
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'intineraryListId': instance.intineraryListId,
      'location': instance.location,
      'locationId': instance.locationId,
      'type': instance.type,
      'is_favorite': instance.isFavorite,
      'is_deleted': instance.isDeleted,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'photo': instance.photo,
    };
