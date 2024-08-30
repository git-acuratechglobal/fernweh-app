import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/state/shared_itinerary_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      return SharedItineraryState(
          authEvent: SharedItineraryEvent.shared, message: message);
    });
  }

  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }
}
