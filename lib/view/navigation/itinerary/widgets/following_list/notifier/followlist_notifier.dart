import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/following_model.dart';

part 'followlist_notifier.g.dart';

@Riverpod(keepAlive: true)
class FollowingNotifier extends _$FollowingNotifier {
  @override
  FutureOr<FollowingState> build() async {
    final response = await ref.watch(apiServiceProvider).getFollowingFriends();
    final Map<int, List<String>> itineraryPhotos = {};
    List<Itinerary> itinerary = response.expand((e) => e.itineries).toList();
    return FollowingState(itineraryPhotos: itineraryPhotos, itineraries: itinerary );
  }
}



final filteredFollowingListProvider=StateProvider< List<Country>>((ref)=>[]);