// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_itinerary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SharedItineraryState {
  SharedItineraryEvent get authEvent => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Create a copy of SharedItineraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedItineraryStateCopyWith<SharedItineraryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedItineraryStateCopyWith<$Res> {
  factory $SharedItineraryStateCopyWith(SharedItineraryState value,
          $Res Function(SharedItineraryState) then) =
      _$SharedItineraryStateCopyWithImpl<$Res, SharedItineraryState>;
  @useResult
  $Res call({SharedItineraryEvent authEvent, String? message});
}

/// @nodoc
class _$SharedItineraryStateCopyWithImpl<$Res,
        $Val extends SharedItineraryState>
    implements $SharedItineraryStateCopyWith<$Res> {
  _$SharedItineraryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedItineraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authEvent = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      authEvent: null == authEvent
          ? _value.authEvent
          : authEvent // ignore: cast_nullable_to_non_nullable
              as SharedItineraryEvent,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedItineraryStateImplCopyWith<$Res>
    implements $SharedItineraryStateCopyWith<$Res> {
  factory _$$SharedItineraryStateImplCopyWith(_$SharedItineraryStateImpl value,
          $Res Function(_$SharedItineraryStateImpl) then) =
      __$$SharedItineraryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SharedItineraryEvent authEvent, String? message});
}

/// @nodoc
class __$$SharedItineraryStateImplCopyWithImpl<$Res>
    extends _$SharedItineraryStateCopyWithImpl<$Res, _$SharedItineraryStateImpl>
    implements _$$SharedItineraryStateImplCopyWith<$Res> {
  __$$SharedItineraryStateImplCopyWithImpl(_$SharedItineraryStateImpl _value,
      $Res Function(_$SharedItineraryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedItineraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authEvent = null,
    Object? message = freezed,
  }) {
    return _then(_$SharedItineraryStateImpl(
      authEvent: null == authEvent
          ? _value.authEvent
          : authEvent // ignore: cast_nullable_to_non_nullable
              as SharedItineraryEvent,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SharedItineraryStateImpl implements _SharedItineraryState {
  const _$SharedItineraryStateImpl({required this.authEvent, this.message});

  @override
  final SharedItineraryEvent authEvent;
  @override
  final String? message;

  @override
  String toString() {
    return 'SharedItineraryState(authEvent: $authEvent, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedItineraryStateImpl &&
            (identical(other.authEvent, authEvent) ||
                other.authEvent == authEvent) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authEvent, message);

  /// Create a copy of SharedItineraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedItineraryStateImplCopyWith<_$SharedItineraryStateImpl>
      get copyWith =>
          __$$SharedItineraryStateImplCopyWithImpl<_$SharedItineraryStateImpl>(
              this, _$identity);
}

abstract class _SharedItineraryState implements SharedItineraryState {
  const factory _SharedItineraryState(
      {required final SharedItineraryEvent authEvent,
      final String? message}) = _$SharedItineraryStateImpl;

  @override
  SharedItineraryEvent get authEvent;
  @override
  String? get message;

  /// Create a copy of SharedItineraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedItineraryStateImplCopyWith<_$SharedItineraryStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
