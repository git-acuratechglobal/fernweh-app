// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_itinerary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyItinerary _$MyItineraryFromJson(Map<String, dynamic> json) => MyItinerary(
      userId: (json['userId'] as num?)?.toInt(),
      intineraryManagementId: json['intineraryManagementId'] as String?,
      type: json['type'] as String?,
      locationId: json['locationId'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: (json['id'] as num?)?.toInt(),
    );
