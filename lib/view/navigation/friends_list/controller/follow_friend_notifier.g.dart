// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_friend_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getFollowingFriendHash() =>
    r'6bc99f374be25fc4c82e6b81acd3fc9e9c877af9';

/// See also [getFollowingFriend].
@ProviderFor(getFollowingFriend)
final getFollowingFriendProvider =
    AutoDisposeFutureProvider<List<FollowingFriends>>.internal(
  getFollowingFriend,
  name: r'getFollowingFriendProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFollowingFriendHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFollowingFriendRef
    = AutoDisposeFutureProviderRef<List<FollowingFriends>>;
String _$followFriendHash() => r'35631f6920bb63733cc4a3650dd3e0a8a6e2f6c0';

/// See also [FollowFriend].
@ProviderFor(FollowFriend)
final followFriendProvider =
    AutoDisposeAsyncNotifierProvider<FollowFriend, FollowFriendState?>.internal(
  FollowFriend.new,
  name: r'followFriendProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$followFriendHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FollowFriend = AutoDisposeAsyncNotifier<FollowFriendState?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
