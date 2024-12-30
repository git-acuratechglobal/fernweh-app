// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followlist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getFollowItinerariesListHash() =>
    r'82d6e968f28f4b938bf53a1e46774af7b54425c2';

/// See also [getFollowItinerariesList].
@ProviderFor(getFollowItinerariesList)
final getFollowItinerariesListProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  getFollowItinerariesList,
  name: r'getFollowItinerariesListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFollowItinerariesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFollowItinerariesListRef
    = AutoDisposeFutureProviderRef<List<String>>;
String _$followingNotifierHash() => r'1517ab898e6953070cae1ec78b3d58cd757af2a1';

/// See also [FollowingNotifier].
@ProviderFor(FollowingNotifier)
final followingNotifierProvider =
    AsyncNotifierProvider<FollowingNotifier, FollowingState>.internal(
  FollowingNotifier.new,
  name: r'followingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$followingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FollowingNotifier = AsyncNotifier<FollowingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
