// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friends_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FriendsState {
  FriendsEvent get friendsEvent => throw _privateConstructorUsedError;
  String? get response => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FriendsStateCopyWith<FriendsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendsStateCopyWith<$Res> {
  factory $FriendsStateCopyWith(
          FriendsState value, $Res Function(FriendsState) then) =
      _$FriendsStateCopyWithImpl<$Res, FriendsState>;
  @useResult
  $Res call({FriendsEvent friendsEvent, String? response});
}

/// @nodoc
class _$FriendsStateCopyWithImpl<$Res, $Val extends FriendsState>
    implements $FriendsStateCopyWith<$Res> {
  _$FriendsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendsEvent = null,
    Object? response = freezed,
  }) {
    return _then(_value.copyWith(
      friendsEvent: null == friendsEvent
          ? _value.friendsEvent
          : friendsEvent // ignore: cast_nullable_to_non_nullable
              as FriendsEvent,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendsStateImplCopyWith<$Res>
    implements $FriendsStateCopyWith<$Res> {
  factory _$$FriendsStateImplCopyWith(
          _$FriendsStateImpl value, $Res Function(_$FriendsStateImpl) then) =
      __$$FriendsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FriendsEvent friendsEvent, String? response});
}

/// @nodoc
class __$$FriendsStateImplCopyWithImpl<$Res>
    extends _$FriendsStateCopyWithImpl<$Res, _$FriendsStateImpl>
    implements _$$FriendsStateImplCopyWith<$Res> {
  __$$FriendsStateImplCopyWithImpl(
      _$FriendsStateImpl _value, $Res Function(_$FriendsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendsEvent = null,
    Object? response = freezed,
  }) {
    return _then(_$FriendsStateImpl(
      friendsEvent: null == friendsEvent
          ? _value.friendsEvent
          : friendsEvent // ignore: cast_nullable_to_non_nullable
              as FriendsEvent,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FriendsStateImpl implements _FriendsState {
  const _$FriendsStateImpl({required this.friendsEvent, this.response});

  @override
  final FriendsEvent friendsEvent;
  @override
  final String? response;

  @override
  String toString() {
    return 'FriendsState(friendsEvent: $friendsEvent, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendsStateImpl &&
            (identical(other.friendsEvent, friendsEvent) ||
                other.friendsEvent == friendsEvent) &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, friendsEvent, response);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendsStateImplCopyWith<_$FriendsStateImpl> get copyWith =>
      __$$FriendsStateImplCopyWithImpl<_$FriendsStateImpl>(this, _$identity);
}

abstract class _FriendsState implements FriendsState {
  const factory _FriendsState(
      {required final FriendsEvent friendsEvent,
      final String? response}) = _$FriendsStateImpl;

  @override
  FriendsEvent get friendsEvent;
  @override
  String? get response;
  @override
  @JsonKey(ignore: true)
  _$$FriendsStateImplCopyWith<_$FriendsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
