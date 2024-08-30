// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addFriendsHash() => r'aaf02a0d89474916675d7e9e3c6810a49762e2bc';

/// See also [addFriends].
@ProviderFor(addFriends)
final addFriendsProvider = AutoDisposeFutureProvider<List<Friends>>.internal(
  addFriends,
  name: r'addFriendsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addFriendsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AddFriendsRef = AutoDisposeFutureProviderRef<List<Friends>>;
String _$getFriendsHash() => r'0615adb8bfc372cd38bb2868c44f1dd9bd87e5c2';

/// See also [getFriends].
@ProviderFor(getFriends)
final getFriendsProvider = FutureProvider<List<Friends>>.internal(
  getFriends,
  name: r'getFriendsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getFriendsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetFriendsRef = FutureProviderRef<List<Friends>>;
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
String _$friendsNotifierHash() => r'ab25e604c8ab8f048b4f506f3b2b441065114fff';

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
String _$searchFriendHash() => r'd5b0235ba7636b88776f0bb6a9bf1287e2a2a037';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
