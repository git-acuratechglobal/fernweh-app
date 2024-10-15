import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/navigation/friends_list/controller/friends_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/api_service/api_service.dart';
import '../../../location_permission/location_service.dart';
import '../../friends_list/model/friends.dart';
import '../../friends_list/model/friends_itinerary.dart';
import '../../itinerary/models/itinerary_places.dart';
import '../../map/model/category.dart';

part 'explore_notifier.g.dart';

@Riverpod(keepAlive: true)
class ExploreNotifier extends _$ExploreNotifier {
  @override
  FutureOr<List<Category>> build() async {
    final position = await ref.watch(currentPositionProvider.future);
    final data = await ref.watch(apiServiceProvider).getCategory(
        position.latitude.toString(), position.longitude.toString(),
        filter: {});
    return data;
  }
}

@Riverpod(keepAlive: true)
class FriendsItineraryNotifier extends _$FriendsItineraryNotifier {
  @override
  FutureOr<List<ItineraryPlaces>> build() async {
    final PaginationResponse<Friends> friendsList =
        await ref.watch(friendListProvider.notifier).loadAllData();
    final List<int> friendsId =
        friendsList.data.map((friend) => friend.id ?? 0).toList();
    final List<FriendsItinerary> friendItineray = [];
    for (int friendId in friendsId) {
      try {
        final List<FriendsItinerary> friendItinerary =
        await ref.watch(apiServiceProvider).getFriendsItinerary(friendId);
        List<FriendsItinerary> filteredList =
        friendItinerary.where((e) => e.type == "1").toList();
        friendItineray.addAll(filteredList);
      } catch (e) {
        print('Failed to fetch itinerary for friend ID $friendId: ${e.toString()}');
      }
    }
    final List<int> itineraryIds =
        friendItineray.map((e) => e.id ?? 0).toList();
    final List<ItineraryPlaces> category = [];
    for (var id in itineraryIds) {
      try{
        final List<ItineraryPlaces> categories =
        await ref.watch(apiServiceProvider).getItineraryPlace(id, null);
        category.addAll(categories);
      }catch (e) {
        print("error:$e");
      }

    }

    return category;
  }
}
