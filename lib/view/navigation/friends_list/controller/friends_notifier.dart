import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/navigation/friends_list/model/friends.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_notifier.g.dart';

@riverpod
FutureOr<List<Friends>> addFriends(AddFriendsRef ref) async {
  final friends = await ref.read(apiServiceProvider).addFriends();
  return friends;
}

@Riverpod(keepAlive: true)
FutureOr<List<Friends>> getFriends(GetFriendsRef ref) async {
  final friends = await ref.watch(apiServiceProvider).getFriends();
  return friends;
}

@Riverpod()
FutureOr<List<Friends>> friendRequest(FriendRequestRef ref) async {
  final friends = await ref.watch(apiServiceProvider).friendRequest();
  return friends;
}

@riverpod
class FriendsNotifier extends _$FriendsNotifier {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> sendRequest(int id, int status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).sendRequest(id, status);
      // ref.invalidate(addFriendsProvider);
      return data;
    });
  }

  Future<void> acceptRequest(int userId,int status,) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).acceptRequest(userId,status);
       ref.invalidate(getFriendsProvider);
      return data;
    });
  }

  Future<void> rejectRequest() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).rejectRequest();
      // ref.invalidate(addFriendsProvider);
      return data;
    });
  }
}


@riverpod
class SearchFriend extends _$SearchFriend {
  @override
  FutureOr<List<Friends>?> build() =>[];



  Future<void> searchFriends(String search)async{
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).searchFriends(search);
      return data;
    });
  }

}