// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getNotesHash() => r'3406f9edac6bdac74bd22f13155610767702b2cf';

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

/// See also [getNotes].
@ProviderFor(getNotes)
const getNotesProvider = GetNotesFamily();

/// See also [getNotes].
class GetNotesFamily extends Family<AsyncValue<List<Notes>>> {
  /// See also [getNotes].
  const GetNotesFamily();

  /// See also [getNotes].
  GetNotesProvider call(
    int itineraryId,
  ) {
    return GetNotesProvider(
      itineraryId,
    );
  }

  @override
  GetNotesProvider getProviderOverride(
    covariant GetNotesProvider provider,
  ) {
    return call(
      provider.itineraryId,
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
  String? get name => r'getNotesProvider';
}

/// See also [getNotes].
class GetNotesProvider extends AutoDisposeFutureProvider<List<Notes>> {
  /// See also [getNotes].
  GetNotesProvider(
    int itineraryId,
  ) : this._internal(
          (ref) => getNotes(
            ref as GetNotesRef,
            itineraryId,
          ),
          from: getNotesProvider,
          name: r'getNotesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getNotesHash,
          dependencies: GetNotesFamily._dependencies,
          allTransitiveDependencies: GetNotesFamily._allTransitiveDependencies,
          itineraryId: itineraryId,
        );

  GetNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itineraryId,
  }) : super.internal();

  final int itineraryId;

  @override
  Override overrideWith(
    FutureOr<List<Notes>> Function(GetNotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetNotesProvider._internal(
        (ref) => create(ref as GetNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itineraryId: itineraryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Notes>> createElement() {
    return _GetNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetNotesProvider && other.itineraryId == itineraryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itineraryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetNotesRef on AutoDisposeFutureProviderRef<List<Notes>> {
  /// The parameter `itineraryId` of this provider.
  int get itineraryId;
}

class _GetNotesProviderElement
    extends AutoDisposeFutureProviderElement<List<Notes>> with GetNotesRef {
  _GetNotesProviderElement(super.provider);

  @override
  int get itineraryId => (origin as GetNotesProvider).itineraryId;
}

String _$addNotesHash() => r'c920b69e084570398ac3cf4bfb6f537ab0bc16f5';

/// See also [AddNotes].
@ProviderFor(AddNotes)
final addNotesProvider =
    AutoDisposeAsyncNotifierProvider<AddNotes, String?>.internal(
  AddNotes.new,
  name: r'addNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddNotes = AutoDisposeAsyncNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
