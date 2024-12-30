
import 'package:json_annotation/json_annotation.dart';

import '../../collections/models/itinerary_model.dart';


part 'following_friends.g.dart';

@JsonSerializable(createToJson: false)
class FollowingFriends {
  FollowingFriends({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.image,
    required this.id,
    required this.userId,
    required this.following,
    required this.itineries,
  });

  final String? firstname;
  final String? lastname;
  final String? email;
  final String? image;
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;
  final int? following;

  final List<Itinerary> itineries;

  factory FollowingFriends.fromJson(Map<String, dynamic> json) => _$FollowingFriendsFromJson(json);
  String? get imageUrl {
    if (image != null) {

      return "http://fernweh.acublock.in/public/$image";
    }
    return null;
  }
  String get fullName {
    if ((firstname == null || firstname!.isEmpty) && (lastname == null || lastname!.isEmpty)) {
      return ''; // Return empty if both firstname and lastname are missing or empty.
    }

    String capitalize(String name) {
      return name[0].toUpperCase() + name.substring(1).toLowerCase();
    }

    String formattedFirstName = firstname != null && firstname!.isNotEmpty
        ? capitalize(firstname!)
        : '';
    String formattedLastName = lastname != null && lastname!.isNotEmpty
        ? capitalize(lastname!)
        : '';

    if (formattedLastName.isEmpty) {
      return formattedFirstName; // Return only firstname if lastname is missing or empty.
    } else {
      return '$formattedFirstName $formattedLastName'; // Return both if available.
    }
  }
}
