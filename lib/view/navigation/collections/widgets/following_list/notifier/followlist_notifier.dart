import 'package:fernweh/services/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/following_model.dart';

part 'followlist_notifier.g.dart';

@Riverpod(keepAlive: true)
class FollowingNotifier extends _$FollowingNotifier {
  @override
  FutureOr<FollowingState> build() async {
    final response =
        await ref.watch(apiServiceProvider).getFollowingItinerary();

    return FollowingState(
        followingFriendsItineraries: response.followingFriendsItineraries,
        followingItineraries: response.followingItineraries);
  }
}


@riverpod
FutureOr<List<String>> getFollowItinerariesList (Ref ref) async {
  return ref.watch(apiServiceProvider).getFollowItinerary() ;
}