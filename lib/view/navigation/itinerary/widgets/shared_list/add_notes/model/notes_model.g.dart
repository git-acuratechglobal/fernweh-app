// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notes _$NotesFromJson(Map<String, dynamic> json) => Notes(
      itineraryId: (json['itinerary_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      userName: json['userName'] as String?,
      userImage: json['userImage'] as String?,
      createdAt: json['created_at'] as String,
    );
