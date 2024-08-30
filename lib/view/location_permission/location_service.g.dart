// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addressHash() => r'e1fcea924ee760b80fc322e0681b68770a6a2329';

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

typedef AddressRef = FutureProviderRef<String>;
String _$currentPositionHash() => r'67333f46e9fcbed35e391cc3fbc9ff79a7a99e68';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
