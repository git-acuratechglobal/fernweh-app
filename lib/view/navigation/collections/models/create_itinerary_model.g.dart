// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_itinerary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItineraryModel _$ItineraryModelFromJson(Map<String, dynamic> json) =>
    ItineraryModel(
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['type'] as String?,
      canView: (json['can_view'] as num?)?.toInt(),
      canEdit: (json['can_edit'] as num?)?.toInt(),
      image: json['image'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: (json['id'] as num?)?.toInt(),
      location: json['location'] as String?,
    );
