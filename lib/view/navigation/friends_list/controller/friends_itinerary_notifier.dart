import 'package:fernweh/services/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../collections/models/itinerary_model.dart';

part 'friends_itinerary_notifier.g.dart';

@riverpod
FutureOr<List<Itinerary>> getFriendsItineraryList(
    Ref ref, int userId) async {
  final itineraryList =
      await ref.watch(apiServiceProvider).getFriendsItinerary(userId);
  return itineraryList;
}
