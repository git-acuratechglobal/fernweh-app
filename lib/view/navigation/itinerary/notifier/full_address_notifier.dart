import 'package:fernweh/services/api_service/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'full_address_notifier.g.dart';

@riverpod
class FullAddressNotifier extends _$FullAddressNotifier {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> getFullAddress({required String placeId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.watch(apiServiceProvider).getFullAdress(placeId: placeId);
    });
  }
}
