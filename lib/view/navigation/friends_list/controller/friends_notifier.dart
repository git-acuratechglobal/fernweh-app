import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/navigation/friends_list/model/friends.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/friends_state.dart';

part 'friends_notifier.g.dart';

// @Riverpod(keepAlive: true)
// FutureOr<List<Friends>> getFriends(GetFriendsRef ref) async {
//   final friends = await ref.watch(apiServiceProvider).getFriends();
//   return friends;
// }

@Riverpod()
FutureOr<List<Friends>> friendRequest(FriendRequestRef ref) async {
  final friends = await ref.watch(apiServiceProvider).friendRequest();
  return friends;
}

@riverpod
class FriendsNotifier extends _$FriendsNotifier {
  @override
  FutureOr<FriendsState?> build() async {
    return null;
  }

  Future<void> sendRequest(int id, int status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).sendRequest(id, status);
      return FriendsState(
          friendsEvent: FriendsEvent.requestSent, response: data);
    });
  }

  Future<void> acceptRequest(
    int userId,
    int status,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data =
          await ref.watch(apiServiceProvider).acceptRequest(userId, status);
       ref.invalidate(friendListProvider);
      return FriendsState(
          friendsEvent: FriendsEvent.requestAccept, response: data);
    });
  }

// Future<void> rejectRequest() async {
//   state = const AsyncLoading();
//   state = await AsyncValue.guard(() async {
//     final data = await ref.watch(apiServiceProvider).rejectRequest();
//     // ref.invalidate(addFriendsProvider);
//     return data;
//   });
// }
}

@riverpod
class SearchFriend extends _$SearchFriend {
  @override
  FutureOr<List<Friends>?> build() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).searchFriends(null);
      return data;
    });
    return state.value;
  }

  Future<void> searchFriends(String? search) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.watch(apiServiceProvider).searchFriends(search);
      return data;
    });
  }
}

@Riverpod(keepAlive: true)
class FriendList extends _$FriendList {
  @override
  FutureOr<PaginationResponse<Friends>> build() {
    return _loadData();
  }

  Future<PaginationResponse<Friends>> _loadData(
      {int? page, String? search}) async {
    return ref.watch(apiServiceProvider).getFriends(page ?? 1, search: search);
  }

  Future<void> loadMore() async {
    try {
      final paginationResponse = state.valueOrNull;
      if (paginationResponse != null &&
          !paginationResponse.isCompleted &&
          canLoadMore()) {
        state = const AsyncLoading<PaginationResponse<Friends>>()
            .copyWithPrevious(state);
        final currentPage = paginationResponse.currentPage;
        final response =
            await ref.read(apiServiceProvider).getFriends(currentPage + 1);
        state = AsyncData(
          PaginationResponse(
            currentPage: response.currentPage,
            totalPages: response.totalPages,
            data: [...paginationResponse.data, ...response.data],
          ),
        );
      }
    } catch (e, st) {
      state = AsyncError<PaginationResponse<Friends>>(e, st)
          .copyWithPrevious(state);
    }
  }

  Future<void> search({String? search}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.watch(apiServiceProvider).getFriends(1, search: search);
    });
  }

  bool canLoadMore() {
    if (state.isLoading) return false;
    if (!state.hasValue) return false;
    if (state.requireValue.isCompleted) return false;
    return true;
  }
}

class PaginationResponse<T> {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final List<T> data;

  PaginationResponse({
    required this.currentPage,
    required this.totalPages,
    required this.data,
    this.totalItems = 0,
  });

  bool get isCompleted => currentPage >= totalPages;

  PaginationResponse<T> copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    List<T>? data,
  }) {
    return PaginationResponse<T>(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      data: data ?? this.data,
    );
  }
}
