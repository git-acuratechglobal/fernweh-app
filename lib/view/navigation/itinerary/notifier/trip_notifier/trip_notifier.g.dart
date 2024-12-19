// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTripHash() => r'19d4fd7fc7c89dd229ed03b794aef714c8fefe73';

/// See also [getTrip].
@ProviderFor(getTrip)
final getTripProvider = AutoDisposeFutureProvider<List<Trip>>.internal(
  getTrip,
  name: r'getTripProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getTripHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTripRef = AutoDisposeFutureProviderRef<List<Trip>>;
String _$tripDetailHash() => r'8f88e2235a4ded9268e7f26970bbefe3352119cb';

/// See also [TripDetail].
@ProviderFor(TripDetail)
final tripDetailProvider =
    AutoDisposeAsyncNotifierProvider<TripDetail, TripDetails?>.internal(
  TripDetail.new,
  name: r'tripDetailProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripDetailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TripDetail = AutoDisposeAsyncNotifier<TripDetails?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
