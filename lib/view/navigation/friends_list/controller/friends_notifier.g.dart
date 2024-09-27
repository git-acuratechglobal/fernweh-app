// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendRequestHash() => r'0fd5c1ce4889d0ab44fd8edfe89bd2a6ec42c012';

/// See also [friendRequest].
@ProviderFor(friendRequest)
final friendRequestProvider = AutoDisposeFutureProvider<List<Friends>>.internal(
  friendRequest,
  name: r'friendRequestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendRequestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FriendRequestRef = AutoDisposeFutureProviderRef<List<Friends>>;
String _$friendsNotifierHash() => r'7ef835620503449f9d463bfb6c5d1fe5730e956d';

/// See also [FriendsNotifier].
@ProviderFor(FriendsNotifier)
final friendsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<FriendsNotifier, FriendsState?>.internal(
  FriendsNotifier.new,
  name: r'friendsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendsNotifier = AutoDisposeAsyncNotifier<FriendsState?>;
String _$searchFriendHash() => r'990f2330e4363bef4ec0891c2a4c8801225d11da';

/// See also [SearchFriend].
@ProviderFor(SearchFriend)
final searchFriendProvider =
    AutoDisposeAsyncNotifierProvider<SearchFriend, List<Friends>?>.internal(
  SearchFriend.new,
  name: r'searchFriendProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchFriendHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchFriend = AutoDisposeAsyncNotifier<List<Friends>?>;
String _$friendListHash() => r'd1a9287937dfa433b6780e06d6572c9fd70a5bae';

/// See also [FriendList].
@ProviderFor(FriendList)
final friendListProvider =
    AsyncNotifierProvider<FriendList, PaginationResponse<Friends>>.internal(
  FriendList.new,
  name: r'friendListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$friendListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendList = AsyncNotifier<PaginationResponse<Friends>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
