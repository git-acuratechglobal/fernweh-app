import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../friends_list/model/friends_itinerary.dart';

part 'all_friends_notifier.g.dart';

@Riverpod(keepAlive: true)
class AllFriendsNotifier extends _$AllFriendsNotifier {
  @override
  FutureOr<List<FriendsItinerary>?> build() async {
    return await getFriendsItineraries();
  }

  Future<List<FriendsItinerary>?> getFriendsItineraries(
      {List<FriendsItinerary>? friendsItineraryList}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard<List<FriendsItinerary>>(() async {
      return friendsItineraryList ?? [];
    });
    state = result;
    return state.valueOrNull;
  }
}
