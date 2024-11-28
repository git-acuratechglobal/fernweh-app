// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesHash() => r'c77539ef5c488994163fd268f0b663b6caad28e5';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider = FutureProvider<List<IntrestedInCategory>>.internal(
  categories,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = FutureProviderRef<List<IntrestedInCategory>>;
String _$userDetailHash() => r'2696d190229f3acb6dc5ec6124b4d557524c91c7';

/// See also [UserDetail].
@ProviderFor(UserDetail)
final userDetailProvider = NotifierProvider<UserDetail, User?>.internal(
  UserDetail.new,
  name: r'userDetailProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userDetailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserDetail = Notifier<User?>;
String _$authNotifierHash() => r'2d70abb4be81eee621086827a783f740200d7c9f';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
