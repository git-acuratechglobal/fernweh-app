import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  User({
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
    required this.token,
    required this.homeLocation,
    required this.homeAddress,
  });

  final int? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final dynamic image;
  final dynamic gender;
  final dynamic dob;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;
  final dynamic phone;

  @JsonKey(name: 'user_role')
  final int? userRole;
  final int? status;
  @JsonKey(name: 'home_location')
  final String? homeLocation;
  @JsonKey(name: 'full_address')
  final String? homeAddress;

  @JsonKey(name: 'is_deleted')
  final int? isDeleted;

  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final String? token;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

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
