// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_itinerary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsItinerary _$FriendsItineraryFromJson(Map<String, dynamic> json) =>
    FriendsItinerary(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      canView: json['can_view'],
      canEdit: json['can_edit'],
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
