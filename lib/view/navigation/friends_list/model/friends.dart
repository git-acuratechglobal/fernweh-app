import 'package:json_annotation/json_annotation.dart';
part 'friends.g.dart';

@JsonSerializable(createToJson: false)
class Friends {
  Friends({
    required this.id,
    required this.name,
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
  });

  final int? id;
  final String? name;
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

  factory Friends.fromJson(Map<String, dynamic> json) => _$FriendsFromJson(json);

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

  String get imageUrl {
    if (image == null) {
      return 'https://t4.ftcdn.net/jpg/02/17/34/67/360_F_217346796_TSg5VcYjsFxZtIDK6Qdctg3yqAapG7Xa.jpg';
    } else {
      return "http://fernweh.acublock.in/public/$image";
    }
  }

}
