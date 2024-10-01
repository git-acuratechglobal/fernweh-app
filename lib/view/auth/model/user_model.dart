import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  User({
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
    required this.token,
  });

  final int? id;
  final dynamic name;
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

  String get imageUrl {
    if (image == null) {
      return 'https://t4.ftcdn.net/jpg/02/17/34/67/360_F_217346796_TSg5VcYjsFxZtIDK6Qdctg3yqAapG7Xa.jpg';
    } else {
      return "http://fernweh.acublock.in/public/$image";
    }
  }
}
