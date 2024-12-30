import 'package:fernweh/services/api_service/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_itinerary.g.dart';

@riverpod
class FollowItinerary extends _$FollowItinerary {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> followItinerary(
      {required int userId, required int itineraryId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref
          .watch(apiServiceProvider)
          .followItinerary(userId, itineraryId);
    });
  }
}
