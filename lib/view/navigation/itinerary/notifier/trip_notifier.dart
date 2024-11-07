import 'package:fernweh/view/navigation/itinerary/models/trip_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripNotifier extends StateNotifier<List<Trip>> {
  TripNotifier() : super(List.empty());

  void addTrip(Trip trip) {
    state = [...state, trip];
  }
}




final tripNotifierProvider=StateNotifierProvider<TripNotifier,List<Trip>>((ref)=>TripNotifier());