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
    required this.address,
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
  final Address? address;
  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  String get formattedDate {
    String start = startDate.toString();
    String end = endDate.toString();
    DateTime startDateTime = DateTime.parse(start);
    DateTime endDateTime = DateTime.parse(end);
    String formattedDate =
        "${startDateTime.month.toString().padLeft(2, '0')}/${startDateTime.day.toString().padLeft(2, '0')}-${endDateTime.month.toString().padLeft(2, '0')}/${endDateTime.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }
}

@JsonSerializable(createToJson: false)
class Address {
  Address({
    required this.city,
    required this.state,
    required this.country,
    required this.stateCode,
  });

  final String? city;
  final String? state;
  final String? country;
  final String? stateCode;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  String get addressFormat {
    return [
      if (city != null && city!.isNotEmpty && city != "null") city,
      if (state != null && state!.isNotEmpty && state != "null") state,
      if (country != null && country!.isNotEmpty && country != "null") country,
    ].join(', ');
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
    required this.friendFirstName,
    required this.friendLastName,
    required this.friendImage,
    required this.friendAddress,
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

  @JsonKey(name: 'friend_firstname')
  final String? friendFirstName;
  @JsonKey(name: 'friend_lastname')
  final String? friendLastName;

  @JsonKey(name: 'friend_image')
  final dynamic friendImage;
  @JsonKey(name: 'friend_address')
  final Address friendAddress;

  factory FriendsTrip.fromJson(Map<String, dynamic> json) =>
      _$FriendsTripFromJson(json);

  String get fullName {
    if ((friendFirstName == null || friendFirstName!.isEmpty) &&
        (friendLastName == null || friendLastName!.isEmpty)) {
      return '';
    }

    String capitalize(String name) {
      return name[0].toUpperCase() + name.substring(1).toLowerCase();
    }

    String formattedFirstName =
        friendFirstName != null && friendFirstName!.isNotEmpty
            ? capitalize(friendFirstName!)
            : '';
    String formattedLastName =
        friendLastName != null && friendLastName!.isNotEmpty
            ? capitalize(friendLastName!)
            : '';

    if (formattedLastName.isEmpty) {
      return formattedFirstName;
    } else {
      return '$formattedFirstName $formattedLastName';
    }
  }
}

@JsonSerializable(createToJson: false)
class TripDetails {
  TripDetails({
    required this.trip,
    required this.friendsTrips,
    this.matchingFriendRecords
  });

  final Trip? trip;

  @JsonKey(name: 'friends_trips')
  final List<FriendsTrip>? friendsTrips;
  @JsonKey(name: 'matchingFriendRecords')
  final List<FriendsTrip>? matchingFriendRecords;

  factory TripDetails.fromJson(Map<String, dynamic> json) =>
      _$TripDetailsFromJson(json);
   
  

  List<FriendsTrip> get uniqueList {
    Map<int, FriendsTrip> uniqueTrips = {};
    final friendTripsData=[...friendsTrips??[],...matchingFriendRecords??[]];
    for (var trip in friendTripsData ) {
      int userId = trip.userId ?? 0;
      if (!uniqueTrips.containsKey(userId) ) {
        uniqueTrips[userId] = trip;
      }
    }
    return uniqueTrips.values.toList();
  }

  Map<String, Map<String, List<Map<String, String>>>>
      getDaysByMonthWithFriends({
    String? filterType,
  }) {
    if (trip == null || (friendsTrips == null&&matchingFriendRecords==null)) {
      return {};
    }
  final List<FriendsTrip> friendTripsData=[...friendsTrips??[],...matchingFriendRecords??[]];
    final Map<String, Map<String, List<Map<String, String>>>> daysByMonth = {};
    final DateTime start = DateTime.parse(trip!.startDate);
    final DateTime end = DateTime.parse(trip!.endDate);

    final mainTripState = trip?.address?.state ?? '';
    final mainTripCity = trip?.address?.city ?? '';
    final mainTripStateCode = trip?.address?.stateCode ?? '';
    DateTime currentDate = start;
    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      final String monthName = DateFormat('MMM').format(currentDate);
      final String day = DateFormat('dd').format(currentDate);

      daysByMonth.putIfAbsent(monthName, () => {});
      daysByMonth[monthName]!.putIfAbsent(day, () => []);

      for (final friendTrip in friendTripsData) {
        final DateTime friendStart = DateTime.parse(friendTrip.startDate);
        final DateTime friendEnd = DateTime.parse(friendTrip.endDate);

        bool isWithinDateRange = !currentDate.isBefore(friendStart) &&
            !currentDate.isAfter(friendEnd);
        final friendAddress = friendTrip.friendAddress;
        final friendState = friendAddress.state ?? '';
        final friendStateCode = friendAddress.stateCode ?? '';
        final friendCity = friendAddress.city ?? '';
        bool matchesFilter = false;
        if (filterType == 'state') {
          matchesFilter = friendState == mainTripState ||
              friendStateCode == mainTripStateCode;
        } else if (filterType == 'city') {
          matchesFilter = friendCity == mainTripCity;
        }

        if (isWithinDateRange && matchesFilter) {
          daysByMonth[monthName]![day]!.add({
            "id": friendTrip.userId.toString(),
            'firstName': friendTrip.friendFirstName ?? "",
            'lastName': friendTrip.friendLastName ?? "",
            'image': friendTrip.friendImage ?? "",
            "fullName": friendTrip.friendFirstName != null &&
                    friendTrip.friendLastName != null
                ? '${friendTrip.friendFirstName} ${friendTrip.friendLastName}'
                : (friendTrip.friendFirstName ??
                    friendTrip.friendLastName ??
                    ""),
            "tripLocation": friendTrip.goingTo ?? ""
          });
        }
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return daysByMonth;
  }
}
