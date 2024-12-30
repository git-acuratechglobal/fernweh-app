import 'package:freezed_annotation/freezed_annotation.dart';
part 'shared_itinerary_state.freezed.dart';


@freezed
class SharedItineraryState with _$SharedItineraryState {
  const factory SharedItineraryState({
    required SharedItineraryEvent authEvent,
    String? message,
  }) = _SharedItineraryState;
}

enum SharedItineraryEvent {
  shared,
unShared
}
