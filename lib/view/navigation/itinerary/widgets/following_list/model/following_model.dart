import 'package:json_annotation/json_annotation.dart';

import '../../../models/itinerary_model.dart';

part 'following_model.g.dart';
@JsonSerializable()
class Place {
  Place({
    required this.id,
    required this.userId,
    required this.intineraryListId,
    required this.location,
    required this.locationId,
    required this.type,
    required this.isFavorite,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.photo,
  });

  final int? id;
  final int? userId;
  final int? intineraryListId;
  final String? location;
  final String? locationId;
  final int? type;

  @JsonKey(name: 'is_favorite')
  final int? isFavorite;

  @JsonKey(name: 'is_deleted')
  final int? isDeleted;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final String? photo;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}


class Country {
  final String name;
  final List<State> states;
  bool isExpanded;

  Country({
    required this.name,
    required this.states,
    this.isExpanded = false,
  });
}

class State {
  final String name;
  final List<City> cities;
  bool isExpanded;

  State({required this.name, required this.cities, this.isExpanded = false});
}

class City {
  final String name;
  final List<Itinerary> itineraries;
  bool isExpanded;

  City(
      {required this.name, required this.itineraries, this.isExpanded = false});

}

List<Country> convertItinerariesToHierarchy(List<Itinerary> itineraryList) {

  final Map<String, Map<String, Map<String, List<Itinerary>>>> hierarchy = {};

  for (var itinerary in itineraryList) {
    if (itinerary.places!.isNotEmpty) {
      for (var place in itinerary.places!) {
        if (place.location != null && place.location!.isNotEmpty) {
          final parts = place.location!.split(',').map((e) => e.trim()).toList();

          if (parts.length >= 3) {
            final countryName = parts.last;
            final stateName = parts[parts.length - 2];
            final cityName = parts.first;
            hierarchy.putIfAbsent(countryName, () => {});
            hierarchy[countryName]!.putIfAbsent(stateName, () => {});
            hierarchy[countryName]![stateName]!.putIfAbsent(cityName, () => []);
            if (!hierarchy[countryName]![stateName]![cityName]!
                .contains(itinerary)) {
              hierarchy[countryName]![stateName]![cityName]!.add(itinerary);
            }
          }
        }
      }
    }
  }

  return hierarchy.entries.map((countryEntry) {
    return Country(
      name: countryEntry.key,
      states: countryEntry.value.entries.map((stateEntry) {
        return State(
          name: stateEntry.key,
          cities: stateEntry.value.entries.map((cityEntry) {
            return City(
              name: cityEntry.key,
              itineraries: cityEntry.value,
            );
          }).toList(),
        );
      }).toList(),
    );
  }).toList();
}


class FollowingState {
  List<Itinerary> itineraries;
  Map<int, List<String>> itineraryPhotos;

  FollowingState({required this.itineraryPhotos, required this.itineraries});
}
