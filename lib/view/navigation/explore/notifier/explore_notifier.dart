import 'package:fernweh/view/navigation/friends_list/controller/friends_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/all_friends_notifier.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../services/api_service/api_service.dart';
import '../../../location_permission/location_service.dart';
import '../../friends_list/model/friends.dart';
import '../../friends_list/model/friends_itinerary.dart';
import '../../itinerary/models/itinerary_places.dart';
import '../../map/model/category.dart';

part 'explore_notifier.g.dart';

@Riverpod(keepAlive: true)
class FriendsItineraryNotifier extends _$FriendsItineraryNotifier {
  @override
  FutureOr<FriendsPlacesState> build() async {
    final position = await ref.read(currentPositionProvider.future);
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
        print(
            'Failed to fetch itinerary for friend ID $friendId: ${e.toString()}');
      }
    }
    await ref
        .read(allFriendsNotifierProvider.notifier)
        .getFriendsItineraries(friendsItineraryList: friendItineray);
    final List<int> itineraryIds =
        friendItineray.map((e) => e.id ?? 0).toList();
    final List<ItineraryPlaces> category = [];
    const double maxDistance = 30000;
    for (var id in itineraryIds) {
      try {
        final List<ItineraryPlaces> categories =
            await ref.watch(apiServiceProvider).getItineraryPlace(id, null);
        final List<ItineraryPlaces> friendItineraryPlacesBasedOnLocation =
            categories.where((place) {
          double placeLat = place.latitude!;
          double placeLng = place.longitude!;
          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            placeLat,
            placeLng,
          );
          return distance <= maxDistance;
        }).toList();
        category.addAll(friendItineraryPlacesBasedOnLocation);
      } catch (e) {
        print("error:$e");
      }
    }
    final data = await ref.watch(apiServiceProvider).getCategory(
        position.latitude.toString(), position.longitude.toString(),
        filter: {});
    return FriendsPlacesState(
        placesList: category,
        filterList: [],
        categories: data,
        filterCategories: []);
  }

  Future<void> filterList(String type) async {
    final data = state;
    final list = data.valueOrNull;
    final List<ItineraryPlaces> filterList =
        list!.placesList.where((e) => e.placeTypes == type).toList();
    final List<Category> filteredCategories =
        list.categories.where((e) => e.type![0] == type).toList();
    state = AsyncData(state.value!.copyWith(
        filterList: filterList,
        filterCategories: filteredCategories,
        isFilterApplied: true));
  }

  Future<void> resetFilter() async {
    state = AsyncData(state.value!.copyWith(
        filterList: [], filterCategories: [], isFilterApplied: false));
  }
}

class FriendsPlacesState {
  final List<ItineraryPlaces> placesList;
  final List<ItineraryPlaces> filterList;
  final List<Category> categories;
  final List<Category> filterCategories;
  final bool isFilterApplied;

  FriendsPlacesState({
    required this.placesList,
    required this.filterList,
    required this.categories,
    required this.filterCategories,
    this.isFilterApplied = false,
  });

  FriendsPlacesState copyWith({
    List<ItineraryPlaces>? placesList,
    List<ItineraryPlaces>? filterList,
    List<Category>? categories,
    List<Category>? filterCategories,
    bool? isFilterApplied,
  }) {
    return FriendsPlacesState(
      placesList: placesList ?? this.placesList,
      filterList: filterList ?? this.filterList,
      categories: categories ?? this.categories,
      filterCategories: filterCategories ?? this.filterCategories,
      isFilterApplied: isFilterApplied ?? this.isFilterApplied,
    );
  }
}
