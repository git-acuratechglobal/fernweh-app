import 'package:fernweh/services/api_service/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invite_friend_notifier.g.dart';

@riverpod
class InviteFriendNotifier extends _$InviteFriendNotifier {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> inviteFriend(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await ref.watch(apiServiceProvider).inviteFriend(email);
      return response;
    });
  }
}
