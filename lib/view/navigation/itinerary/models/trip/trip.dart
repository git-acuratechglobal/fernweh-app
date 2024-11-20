import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

@JsonSerializable(createToJson: false)
class Trip {
  Trip({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.goingTo,
    required this.placeId,
    required this.latLong,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'start_date')
  final dynamic startDate;

  @JsonKey(name: 'end_date')
  final dynamic endDate;

  @JsonKey(name: 'going_to')
  final String? goingTo;

  @JsonKey(name: 'place_id')
  final dynamic placeId;

  @JsonKey(name: 'lat_long')
  final dynamic latLong;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final int? id;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  String get formattedDate {
    String start = startDate.toString();
    String end = endDate.toString();
    DateTime startDateTime = DateTime.parse(start);
    DateTime endDateTime = DateTime.parse(end);
    String formattedDate =
        "${startDateTime.day.toString().padLeft(2, '0')}/${startDateTime.month.toString().padLeft(2, '0')}-${endDateTime.day.toString().padLeft(2, '0')}/${endDateTime.month.toString().padLeft(2, '0')}";
    return formattedDate;
  }
}

@JsonSerializable(createToJson: false)
class FriendsTrip {
  FriendsTrip({
    required this.tripId,
    required this.userId,
    required this.goingTo,
    required this.startDate,
    required this.endDate,
    required this.friendName,
    required this.friendImage,
  });

  @JsonKey(name: 'trip_id')
  final int? tripId;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'going_to')
  final String? goingTo;

  @JsonKey(name: 'start_date')
  final dynamic startDate;

  @JsonKey(name: 'end_date')
  final dynamic endDate;

  @JsonKey(name: 'friend_name')
  final String? friendName;

  @JsonKey(name: 'friend_image')
  final dynamic friendImage;

  factory FriendsTrip.fromJson(Map<String, dynamic> json) => _$FriendsTripFromJson(json);

}
@JsonSerializable(createToJson: false)
class TripDetails {
  TripDetails({
    required this.trip,
    required this.friendsTrips,
  });

  final Trip? trip;

  @JsonKey(name: 'friends_trips')
  final List<FriendsTrip>? friendsTrips;

  factory TripDetails.fromJson(Map<String, dynamic> json) => _$TripDetailsFromJson(json);
  Map<String, Map<String, List<Map<String, String>>>> get getDaysByMonthWithFriends {
    if (trip == null || friendsTrips == null) {
      return {};
    }

    final Map<String, Map<String, List<Map<String, String>>>> daysByMonth = {};
    final DateTime start = DateTime.parse(trip!.startDate);
    final DateTime end = DateTime.parse(trip!.endDate);

    DateTime currentDate = start;
    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      final String monthName = DateFormat('MMM').format(currentDate);
      final String day = DateFormat('dd').format(currentDate);

      daysByMonth.putIfAbsent(monthName, () => {});
      daysByMonth[monthName]!.putIfAbsent(day, () => []);

      // Check for matching friends
      for (final friendTrip in friendsTrips!) {
        final DateTime friendStart = DateTime.parse(friendTrip.startDate);
        final DateTime friendEnd = DateTime.parse(friendTrip.endDate);

        if (!currentDate.isBefore(friendStart) && !currentDate.isAfter(friendEnd)) {
          daysByMonth[monthName]![day]!.add({
            'name': friendTrip.friendName??"",
            'image': friendTrip.friendImage ?? '',
          });
        }
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return daysByMonth;
  }

}