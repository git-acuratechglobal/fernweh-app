import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/navigation/friends_list/model/following_friends.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_friend_notifier.g.dart';

@riverpod
class FollowFriend extends _$FollowFriend {
  @override
  FutureOr<FollowFriendState?> build() async {
    return null;
  }

  Future<void> followFriend(int id) async {
    try {
      state = const AsyncLoading();
      final followFriend =
          await ref.watch(apiServiceProvider).followUser(id: id);
      state = AsyncData(followFriend);
    } catch (e) {
      state = AsyncError({"error": e, "id": id}, StackTrace.current);
    }
  }
}

@riverpod
Future<List<FollowingFriends>> getFollowingFriend(Ref ref) async {
  return ref.watch(apiServiceProvider).getFollowingFriends();
}

class FollowFriendState {
  String message;
  int id;

  FollowFriendState({required this.message, required this.id});
}
