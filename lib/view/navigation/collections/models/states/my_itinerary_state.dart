import '../my_itinerary.dart';

sealed class MyItineraryState {}

class MyItineraryInitialState extends MyItineraryState {}

class MyItineraryLoading extends MyItineraryState {}

class MyItineraryCreatedState extends MyItineraryState {
  final MyItinerary myItinerary;

  MyItineraryCreatedState({required this.myItinerary});
}

class MyItineraryUpdatedState extends MyItineraryState {}

class MyItineraryErrorState extends MyItineraryState {
  final Object? error;

  MyItineraryErrorState({required this.error});
}
