// import 'package:freezed_annotation/freezed_annotation.dart';
// part 'user_itinerary_state.freezed.dart';
//
// @freezed
// class UserItineraryState with _$UserItineraryState{
//   const factory UserItineraryState({
//     required UserItineraryEvent event,
//      String? message,
//
//   }) = _UserItineraryState;
// }
//
// enum UserItineraryEvent{
//   itineraryUpdated,
//   itineraryDeleted,
// }


import '../create_itinerary_model.dart';
import '../itinerary_model.dart';

sealed class UserItineraryState {}

class UserItineraryInitial extends UserItineraryState {}

class UserItineraryLoading extends UserItineraryState {}

class UserItineraryCreated extends UserItineraryState {
 final ItineraryModel itinerary;
  UserItineraryCreated({required this.itinerary});

}

class SavedLoading extends UserItineraryState {}

class Saved extends UserItineraryState {}

class DeleteLoading extends UserItineraryState {}

class Deleted extends UserItineraryState {}

class UserItineraryError extends UserItineraryState {
  final Object? error;

  UserItineraryError({required this.error});
}

// enum UserItineraryState{
//   initial,
//   savedLoading,
//   saved,
//   deleteLoading,
//   deleted,
//   UserItineraryState()
// }
