import 'package:fernweh/services/api_service/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../notifier/itinerary_notifier.dart';
import '../state/shared_itinerary_state.dart';

part 'shareItinerary_notifier.g.dart';

@riverpod
class SharedItinerary extends _$SharedItinerary {
  final Map<String, dynamic> _formData = {};

  @override
  FutureOr<SharedItineraryState?> build() => null;

  Future<void> shareItinerary() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final message = await ref
          .watch(apiServiceProvider)
          .shareItinerary(_formData, _formData["itineraryId"]);
      ref.invalidate(getUserItineraryProvider);
      return SharedItineraryState(
          authEvent: SharedItineraryEvent.shared, message: message);
    });
  }

  Future<void> unShareItinerary() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final message = await ref
          .watch(apiServiceProvider)
          .unShareItinerary(_formData, _formData["itineraryId"]);
      ref.invalidate(getUserItineraryProvider);
      return SharedItineraryState(
          authEvent: SharedItineraryEvent.unShared, message: message);
    });
  }

  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }
  void updateFromList(String key, List<String> userIdList) {
    final commaSeparatedIds = userIdList.join(",");
    _formData[key] = commaSeparatedIds;
  }
}
