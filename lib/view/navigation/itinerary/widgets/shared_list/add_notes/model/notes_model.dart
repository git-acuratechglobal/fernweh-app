import 'package:json_annotation/json_annotation.dart';

part 'notes_model.g.dart';

@JsonSerializable(createToJson: false)
class Notes {
  Notes({
    required this.itineraryId,
    required this.userId,
    required this.notes,
    required this.userName,
    required this.userImage,
    required this.createdAt
  });

  @JsonKey(name: 'itinerary_id')
  final int? itineraryId;

  @JsonKey(name: 'user_id')
  final int? userId;
  final String? notes;
  final String? userName;
  final String? userImage;
  @JsonKey(name: 'created_at')
  final String createdAt;

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);

}
