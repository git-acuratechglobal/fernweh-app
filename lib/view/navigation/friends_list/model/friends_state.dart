import 'package:freezed_annotation/freezed_annotation.dart';
part 'friends_state.freezed.dart';

@freezed
class FriendsState with _$FriendsState {
  const factory FriendsState({
    required FriendsEvent friendsEvent,
    String? response,
  }) = _FriendsState;
}

enum FriendsEvent {
  requestAccept,
  requestSent
}