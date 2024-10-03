import 'package:json_annotation/json_annotation.dart';

part 'notes_model.g.dart';

@JsonSerializable(createToJson: false)
class Notes {
  Notes(
      {required this.itineraryId,
      required this.userId,
      required this.notes,
      required this.userName,
      required this.userImage,
      required this.createdAt});

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

  String get imageUrl {
    if (userImage == null) {
      return 'https://t4.ftcdn.net/jpg/02/17/34/67/360_F_217346796_TSg5VcYjsFxZtIDK6Qdctg3yqAapG7Xa.jpg';
    } else {
      return "http://fernweh.acublock.in/public/$userImage";
    }
  }
}
