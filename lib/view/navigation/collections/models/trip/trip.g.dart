// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      userId: (json['user_id'] as num?)?.toInt(),
      startDate: json['start_date'],
      endDate: json['end_date'],
      goingTo: json['going_to'] as String?,
      placeId: json['place_id'],
      latLong: json['lat_long'],
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: (json['id'] as num?)?.toInt(),
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      stateCode: json['stateCode'] as String?,
    );

FriendsTrip _$FriendsTripFromJson(Map<String, dynamic> json) => FriendsTrip(
      tripId: (json['trip_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      goingTo: json['going_to'] as String?,
      startDate: json['start_date'],
      endDate: json['end_date'],
      friendFirstName: json['friend_firstname'] as String?,
      friendLastName: json['friend_lastname'] as String?,
      friendImage: json['friend_image'],
      friendAddress:
          Address.fromJson(json['friend_address'] as Map<String, dynamic>),
    );

TripDetails _$TripDetailsFromJson(Map<String, dynamic> json) => TripDetails(
      trip: json['trip'] == null
          ? null
          : Trip.fromJson(json['trip'] as Map<String, dynamic>),
      friendsTrips: (json['friends_trips'] as List<dynamic>?)
          ?.map((e) => FriendsTrip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
