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
String _$currentPositionHash() => r'29d4f3697224c20b07594ce396d4c7c8717a5306';

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
