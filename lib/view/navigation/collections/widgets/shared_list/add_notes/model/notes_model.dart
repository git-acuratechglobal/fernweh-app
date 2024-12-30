import 'package:json_annotation/json_annotation.dart';

part 'notes_model.g.dart';

@JsonSerializable(createToJson: false)
class Notes {
  Notes(
      {required this.itineraryId,
      required this.userId,
      required this.notes,
      required this.firstName,
        required this.lastName,
      required this.userImage,
      required this.createdAt});

  @JsonKey(name: 'itinerary_id')
  final int? itineraryId;

  @JsonKey(name: 'user_id')
  final int? userId;
  final String? notes;
  @JsonKey(name: 'userfirstName')
  final String? firstName;
  @JsonKey(name: 'userlastName')
  final String? lastName;
  final String? userImage;
  @JsonKey(name: 'created_at')
  final String createdAt;

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);

  String? get imageUrl {
    if (userImage != null) {
      return "http://fernweh.acublock.in/public/$userImage";
    } else {
      return null;
    }
  }
  String get fullName {
    if ((firstName == null || firstName!.isEmpty) && (lastName == null || lastName!.isEmpty)) {
      return ''; // Return empty if both firstname and lastname are missing or empty.
    }

    String capitalize(String name) {
      return name[0].toUpperCase() + name.substring(1).toLowerCase();
    }

    String formattedFirstName = firstName != null && firstName!.isNotEmpty
        ? capitalize(firstName!)
        : '';
    String formattedLastName = lastName != null && lastName!.isNotEmpty
        ? capitalize(lastName!)
        : '';

    if (formattedLastName.isEmpty) {
      return formattedFirstName; // Return only firstname if lastname is missing or empty.
    } else {
      return '$formattedFirstName $formattedLastName'; // Return both if available.
    }
  }
}
