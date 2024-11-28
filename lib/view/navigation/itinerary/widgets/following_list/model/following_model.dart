import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/itinerary_model.dart';

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
    if (itinerary.location != null && itinerary.location!.isNotEmpty) {
      final parts =
          itinerary.location!.split(',').map((e) => e.trim()).toList();

      if (parts.length >= 3) {
        final countryName = parts.last;
        final stateName = parts[parts.length - 2];
        final cityName = parts.first;

        hierarchy.putIfAbsent(countryName, () => {});
        hierarchy[countryName]!.putIfAbsent(stateName, () => {});
        hierarchy[countryName]![stateName]!.putIfAbsent(cityName, () => []);
        hierarchy[countryName]![stateName]![cityName]!.add(itinerary);
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
