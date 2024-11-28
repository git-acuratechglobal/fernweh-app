import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/itinerary_places.dart';
import '../model/following_model.dart';

part 'followlist_notifier.g.dart';

@Riverpod(keepAlive: true)
class FollowingNotifier extends _$FollowingNotifier {
  @override
  FutureOr<FollowingState> build() async {
    final response = await ref.watch(apiServiceProvider).getFollowingFriends();
    final Map<int, List<String>> itineraryPhotos = {};
    List<Itinerary> itinerary = response.expand((e) => e.itineries).toList();
    for (var itinerary in itinerary) {
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
    return FollowingState(itineraryPhotos: itineraryPhotos, itineraries: itinerary );
  }
}



final filteredFollowingListProvider=StateProvider< List<Country>>((ref)=>[]);