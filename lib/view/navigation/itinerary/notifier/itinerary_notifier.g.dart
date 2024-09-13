// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUserItineraryHash() => r'd55908a9da2f0fd8af8c334db305870f0e3620fd';

/// See also [getUserItinerary].
@ProviderFor(getUserItinerary)
final getUserItineraryProvider = FutureProvider<UserItinerary>.internal(
  getUserItinerary,
  name: r'getUserItineraryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserItineraryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetUserItineraryRef = FutureProviderRef<UserItinerary>;
String _$userItineraryNotifierHash() =>
    r'205994ea6b28cfba10da18490a3fa8c12638b70c';

/// See also [UserItineraryNotifier].
@ProviderFor(UserItineraryNotifier)
final userItineraryNotifierProvider = AutoDisposeNotifierProvider<
    UserItineraryNotifier, UserItineraryState>.internal(
  UserItineraryNotifier.new,
  name: r'userItineraryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userItineraryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserItineraryNotifier = AutoDisposeNotifier<UserItineraryState>;
String _$myItineraryNotifierHash() =>
    r'26cec7e3385ab365f481e65194767c1f99bafee3';

/// See also [MyItineraryNotifier].
@ProviderFor(MyItineraryNotifier)
final myItineraryNotifierProvider =
    AutoDisposeNotifierProvider<MyItineraryNotifier, MyItineraryState>.internal(
  MyItineraryNotifier.new,
  name: r'myItineraryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myItineraryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyItineraryNotifier = AutoDisposeNotifier<MyItineraryState>;
String _$itineraryPlacesNotifierHash() =>
    r'e470354dc58a5f2b7e29ee44912569955bd0c90d';

/// See also [ItineraryPlacesNotifier].
@ProviderFor(ItineraryPlacesNotifier)
final itineraryPlacesNotifierProvider = AsyncNotifierProvider<
    ItineraryPlacesNotifier, List<ItineraryPlaces>>.internal(
  ItineraryPlacesNotifier.new,
  name: r'itineraryPlacesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$itineraryPlacesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ItineraryPlacesNotifier = AsyncNotifier<List<ItineraryPlaces>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
