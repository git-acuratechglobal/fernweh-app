import 'package:json_annotation/json_annotation.dart';
part 'friends.g.dart';

@JsonSerializable(createToJson: false)
class Friends {
  Friends({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.image,
    required this.gender,
    required this.dob,
    required this.fcmToken,
    required this.phone,
    required this.userRole,
    required this.status,
    required this.isDeleted,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.itineraryCount,
    required this.userFollowed,
  });

  final int? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final dynamic image;
  final String? gender;
  final dynamic dob;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;
  final String? phone;

  @JsonKey(name: 'user_role')
  final int? userRole;
  final int? status;

  @JsonKey(name: 'is_deleted')
  final int? isDeleted;

  @JsonKey(name: 'email_verified_at')
  final dynamic emailVerifiedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'itinerary_count')
  final int? itineraryCount;
  @JsonKey(name: 'user_followed')
  final String? userFollowed;

  factory Friends.fromJson(Map<String, dynamic> json) => _$FriendsFromJson(json);



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


  String? get imageUrl {
    if (image!=null && image!="") {
      return "http://fernweh.acublock.in/public/$image";
    }
    return null;
  }

}
