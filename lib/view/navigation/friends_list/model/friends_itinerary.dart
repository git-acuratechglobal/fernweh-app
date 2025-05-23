import 'package:fernweh/utils/common/common.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../collections/models/itinerary_model.dart';


part 'friends_itinerary.g.dart';

@JsonSerializable(createToJson: false)
class FriendsItinerary {
  FriendsItinerary({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.image,
    required this.canView,
    required this.canEdit,
    required this.isDeleted,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;
  final String? name;
  final String? type;
  final String? image;

  @JsonKey(name: 'can_view')
  final dynamic canView;

  @JsonKey(name: 'can_edit')
  final dynamic canEdit;

  @JsonKey(name: 'is_deleted')
  final int? isDeleted;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final String? location;

  factory FriendsItinerary.fromJson(Map<String, dynamic> json) =>
      _$FriendsItineraryFromJson(json);

  String get imageUrl {
    if (image == null) {
      return "https://cdn-icons-png.flaticon.com/512/2343/2343940.png";
    } else {
      return "${Common.baseUrl}/public/$image";
    }
  }
}

class AllFriendsState {
  List<Itinerary> friendsList;

  Map<int, List<String>>? itineraryPhotos;

  AllFriendsState({required this.friendsList,  this.itineraryPhotos});
}
