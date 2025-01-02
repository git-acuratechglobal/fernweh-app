import 'package:json_annotation/json_annotation.dart';

import '../widgets/following_list/model/following_model.dart';

part 'itinerary_model.g.dart';

@JsonSerializable()
class UserItinerary {
  UserItinerary({
    required this.userIteneries,
    required this.sharedIteneries,
  });

  final List<Itenery>? userIteneries;
  final List<Itenery>? sharedIteneries;

  factory UserItinerary.fromJson(Map<String, dynamic> json) =>
      _$UserItineraryFromJson(json);

  Map<String, dynamic> toJson() => _$UserItineraryToJson(this);

  List<Itenery> getCombinedItineraries(int currentUserId) {
    List<Itenery> combinedItineraries = [];
    if (userIteneries != null) {
      combinedItineraries.addAll(userIteneries!);
    }
    if (sharedIteneries != null) {
      combinedItineraries.addAll(sharedIteneries!.where(
        (itinerary) => itinerary.canEdit!.any((can) => can.id == currentUserId),
      ));
    }
    return combinedItineraries;
  }
}

@JsonSerializable()
class Itenery {
  Itenery({
    required this.itinerary,
    required this.canView,
    required this.canEdit,
    required this.placesCount,
  });

  final Itinerary? itinerary;
  final List<Can>? canView;
  final List<Can>? canEdit;
  final int? placesCount;

  factory Itenery.fromJson(Map<String, dynamic> json) =>
      _$IteneryFromJson(json);

  Map<String, dynamic> toJson() => _$IteneryToJson(this);
}

@JsonSerializable()
class Can {
  Can({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.image,
  });

  final int? id;
  final String? firstname;
  final String? lastname;
  final String? image;

  factory Can.fromJson(Map<String, dynamic> json) => _$CanFromJson(json);

  Map<String, dynamic> toJson() => _$CanToJson(this);

  String? get imageUrl {
    if (image != null) {
      return "http://fernweh.acublock.in/public/$image";
    } else {
      return null;
    }
  }

  String get fullName {
    if ((firstname == null || firstname!.isEmpty) && (lastname == null || lastname!.isEmpty)) {
      return ''; // Return empty if both firstname and lastname are missing or empty.
    }

    String capitalize(String name) {
      return name[0].toUpperCase() + name.substring(1).toLowerCase();
    }

    String formattedFirstName = firstname != null && firstname!.isNotEmpty
        ? capitalize(firstname!)
        : '';
    String formattedLastName = lastname != null && lastname!.isNotEmpty
        ? capitalize(lastname!)
        : '';

    if (formattedLastName.isEmpty) {
      return formattedFirstName; // Return only firstname if lastname is missing or empty.
    } else {
      return '$formattedFirstName $formattedLastName'; // Return both if available.
    }
  }


}

@JsonSerializable()
class Itinerary {
  Itinerary({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.image,
    required this.canView,
    required this.canEdit,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.haveAccess,
    required this.shareUrl,
    required this.location,
     this.placesCount,
    this.places,
    required this.owner
  });

  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;
  final String? name;
  final String? type;
  final String? image;

  @JsonKey(name: 'can_view')
  final String? canView;

  @JsonKey(name: 'can_edit')
  final String? canEdit;

  @JsonKey(name: 'is_deleted')
  final int? isDeleted;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'have_access')
  final String? haveAccess;
  final String? shareUrl;
  final String? location;
  final int ?placesCount;
  @JsonKey(name: 'places')
  final List<Place>? places;
  final String? owner;

  factory Itinerary.fromJson(Map<String, dynamic> json) =>
      _$ItineraryFromJson(json);

  Map<String, dynamic> toJson() => _$ItineraryToJson(this);

  String get imageUrl {
    if (image == null) {
      return "https://cdn-icons-png.flaticon.com/512/2343/2343940.png";
    } else {
      return "http://fernweh.acublock.in/public/$image";
    }
  }

  List<String> get placesUrls{
    if(places!= null){
      return places!.map((place) => place.photo??"").toList();
    }
    return [];
  }
  String? get ownerFullName {
    if (owner!.isEmpty) return owner;
    return owner!
        .split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }
}

List<Itinerary> get userItinerarydummyList {
  return List.generate(8, (index) {
    return Itinerary(
      owner: "",
      placesCount: 0,
      location: "",
        id: null,
        userId: null,
        name: 'dummy name',
        type: '',
        image: "assets/images/attractions.png",
        canView: '',
        canEdit: '',
        isDeleted: null,
        createdAt: null,
        updatedAt: null,
        haveAccess: '',
        shareUrl: '');
  });
}

class ItineraryTabState {
  UserItinerary userItinerary;
  Map<int, List<String>> itineraryPhotos;

  ItineraryTabState(
      {required this.userItinerary, required this.itineraryPhotos});
}
