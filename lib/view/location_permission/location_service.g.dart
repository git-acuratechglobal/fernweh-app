// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addressHash() => r'1e5cd4c286f8899316ee42aed7b57fe820e576a4';

/// See also [address].
@ProviderFor(address)
final addressProvider = FutureProvider<String>.internal(
  address,
  name: r'addressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddressRef = FutureProviderRef<String>;
String _$currentPositionHash() => r'a56e4092a5822d607aa90011f389a6b8d74eda58';

/// See also [CurrentPosition].
@ProviderFor(CurrentPosition)
final currentPositionProvider =
    AsyncNotifierProvider<CurrentPosition, Position>.internal(
  CurrentPosition.new,
  name: r'currentPositionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPositionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentPosition = AsyncNotifier<Position>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
