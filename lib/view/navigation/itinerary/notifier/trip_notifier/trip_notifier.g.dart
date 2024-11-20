// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTripHash() => r'ea951342dd03dbed596c86eb46b29b3a6426ce60';

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
String _$tripDetailHash() => r'92da87dbc44a415ab7ba5fcdc6e68bc4f2d0f7e3';

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
