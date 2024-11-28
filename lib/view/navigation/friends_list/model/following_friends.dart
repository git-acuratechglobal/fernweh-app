
import 'package:json_annotation/json_annotation.dart';

import '../../itinerary/models/itinerary_model.dart';

part 'following_friends.g.dart';

@JsonSerializable(createToJson: false)
class FollowingFriends {
  FollowingFriends({
    required this.name,
    required this.email,
    required this.image,
    required this.id,
    required this.userId,
    required this.following,
    required this.itineries,
  });

  final String? name;
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
    if (name == null || name!.isEmpty) {
      return '';
    }

    // Split the full name by spaces
    List<String> nameParts = name!.split(' ');

    // The first part is considered the first name
    String firstName = nameParts[0];

    // Check if there is a last name
    if (nameParts.length > 1) {
      // Get the first letter of the last name
      String lastNameInitial = nameParts.last[0];
      return '$firstName $lastNameInitial.';
    } else {
      // If no last name, return just the first name
      return firstName;
    }
  }
}
