// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_itinerary_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getFriendsItineraryListHash() =>
    r'3542a1853bde6833452306deb9db710331a2b36d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getFriendsItineraryList].
@ProviderFor(getFriendsItineraryList)
const getFriendsItineraryListProvider = GetFriendsItineraryListFamily();

/// See also [getFriendsItineraryList].
class GetFriendsItineraryListFamily
    extends Family<AsyncValue<List<Itinerary>>> {
  /// See also [getFriendsItineraryList].
  const GetFriendsItineraryListFamily();

  /// See also [getFriendsItineraryList].
  GetFriendsItineraryListProvider call(
    int userId,
  ) {
    return GetFriendsItineraryListProvider(
      userId,
    );
  }

  @override
  GetFriendsItineraryListProvider getProviderOverride(
    covariant GetFriendsItineraryListProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getFriendsItineraryListProvider';
}

/// See also [getFriendsItineraryList].
class GetFriendsItineraryListProvider
    extends AutoDisposeFutureProvider<List<Itinerary>> {
  /// See also [getFriendsItineraryList].
  GetFriendsItineraryListProvider(
    int userId,
  ) : this._internal(
          (ref) => getFriendsItineraryList(
            ref as GetFriendsItineraryListRef,
            userId,
          ),
          from: getFriendsItineraryListProvider,
          name: r'getFriendsItineraryListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFriendsItineraryListHash,
          dependencies: GetFriendsItineraryListFamily._dependencies,
          allTransitiveDependencies:
              GetFriendsItineraryListFamily._allTransitiveDependencies,
          userId: userId,
        );

  GetFriendsItineraryListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<List<Itinerary>> Function(GetFriendsItineraryListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFriendsItineraryListProvider._internal(
        (ref) => create(ref as GetFriendsItineraryListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Itinerary>> createElement() {
    return _GetFriendsItineraryListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFriendsItineraryListProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFriendsItineraryListRef
    on AutoDisposeFutureProviderRef<List<Itinerary>> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _GetFriendsItineraryListProviderElement
    extends AutoDisposeFutureProviderElement<List<Itinerary>>
    with GetFriendsItineraryListRef {
  _GetFriendsItineraryListProviderElement(super.provider);

  @override
  int get userId => (origin as GetFriendsItineraryListProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
