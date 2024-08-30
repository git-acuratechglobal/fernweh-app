// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
