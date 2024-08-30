// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intrestedin_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntrestedInCategory _$IntrestedInCategoryFromJson(Map<String, dynamic> json) =>
    IntrestedInCategory(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
