import 'package:json_annotation/json_annotation.dart';

part 'my_itinerary.g.dart';

@JsonSerializable(createToJson: false)
class MyItinerary {
  MyItinerary({
    required this.userId,
    required this.intineraryManagementId,
    required this.type,
    required this.locationId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  final int? userId;
  final String? intineraryManagementId;
  final String? type;
  final String? locationId;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final int? id;

  factory MyItinerary.fromJson(Map<String, dynamic> json) => _$MyItineraryFromJson(json);

}
