import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/navigation/friends_list/model/friends_itinerary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_itinerary_notifier.g.dart';

@riverpod
FutureOr<List<FriendsItinerary>> getFriendsItineraryList(
    GetFriendsItineraryListRef ref, int userId) async {
  final itineraryList =
      await ref.watch(apiServiceProvider).getFriendsItinerary(userId);
  return itineraryList;
}
