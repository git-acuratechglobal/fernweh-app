import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/api_service/api_service.dart';
import '../../friends_list/model/friends_itinerary.dart';
import '../models/itinerary_model.dart';
import '../models/itinerary_places.dart';

part 'all_friends_notifier.g.dart';

@Riverpod(keepAlive: false)
class AllFriendsNotifier extends _$AllFriendsNotifier {
  @override
  FutureOr<AllFriendsState> build() async {
    return await getFriendsItineraries();
  }

  Future<AllFriendsState> getFriendsItineraries(
      {List<Itinerary> ?friendsItineraryList}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final Map<int, List<String>> itineraryPhotos = {};
      if(friendsItineraryList!.isNotEmpty){
        for (var itinerary in friendsItineraryList) {
          final int itineraryId = itinerary.id ?? 0;
          if ((itinerary.placesCount ?? 0) > 0) {
            final List<ItineraryPlaces> itineraryPlaces = await ref
                .read(apiServiceProvider)
                .getItineraryPlace(itineraryId, null);
            final List<String> photoUrls = itineraryPlaces
                .where((place) => place.photo != null)
                .map((place) => place.photo ?? "")
                .toList();
            itineraryPhotos[itineraryId] = photoUrls;
          }
        }
      }



      return AllFriendsState(friendsList: friendsItineraryList??[],itineraryPhotos: itineraryPhotos );
    });
    state = result;
    return state.valueOrNull!;
  }

}
