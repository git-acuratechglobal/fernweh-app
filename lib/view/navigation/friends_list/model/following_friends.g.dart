// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following_friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowingFriends _$FollowingFriendsFromJson(Map<String, dynamic> json) =>
    FollowingFriends(
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      following: (json['following'] as num?)?.toInt(),
      itineries: (json['itineries'] as List<dynamic>)
          .map((e) => Itinerary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
