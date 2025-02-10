// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addressHash() => r'6b70548951a3965647231a9fedc71b04ad93f22a';

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
String _$currentPositionHash() => r'55e7c6eb5185fcfb678a4b79621471def3a6b8db';

/// See also [CurrentPosition].
@ProviderFor(CurrentPosition)
final currentPositionProvider =
    AutoDisposeAsyncNotifierProvider<CurrentPosition, Position>.internal(
  CurrentPosition.new,
  name: r'currentPositionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPositionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentPosition = AutoDisposeAsyncNotifier<Position>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
