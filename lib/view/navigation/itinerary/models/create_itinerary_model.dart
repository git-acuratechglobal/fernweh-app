
import 'package:json_annotation/json_annotation.dart';

part 'create_itinerary_model.g.dart';

@JsonSerializable(createToJson: false)
class ItineraryModel {
  ItineraryModel({
    required this.userId,
    required this.name,
    required this.type,
    required this.canView,
    required this.canEdit,
    required this.image,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  @JsonKey(name: 'user_id')
  final int? userId;
  final String? name;
  final String? type;

  @JsonKey(name: 'can_view')
  final int? canView;

  @JsonKey(name: 'can_edit')
  final int? canEdit;
  final String? image;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final int? id;

  factory ItineraryModel.fromJson(Map<String, dynamic> json) => _$ItineraryModelFromJson(json);

}
