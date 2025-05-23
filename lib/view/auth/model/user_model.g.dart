// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      image: json['image'],
      gender: json['gender'],
      dob: json['dob'],
      fcmToken: json['fcm_token'] as String?,
      phone: json['phone'],
      userRole: (json['user_role'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      token: json['token'] as String?,
      homeLocation: json['home_location'] as String?,
      homeAddress: json['full_address'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'image': instance.image,
      'gender': instance.gender,
      'dob': instance.dob,
      'fcm_token': instance.fcmToken,
      'phone': instance.phone,
      'user_role': instance.userRole,
      'status': instance.status,
      'home_location': instance.homeLocation,
      'full_address': instance.homeAddress,
      'is_deleted': instance.isDeleted,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'token': instance.token,
    };
