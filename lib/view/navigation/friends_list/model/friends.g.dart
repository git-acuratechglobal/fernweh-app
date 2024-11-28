// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'],
      gender: json['gender'] as String?,
      dob: json['dob'],
      fcmToken: json['fcm_token'] as String?,
      phone: json['phone'] as String?,
      userRole: (json['user_role'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      itineraryCount: (json['itinerary_count'] as num?)?.toInt(),
      userFollowed: json['user_followed'] as String?,
    );
