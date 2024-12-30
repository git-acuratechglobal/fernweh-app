import 'package:fernweh/services/api_service/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_trip_notifier.g.dart';

@riverpod
class CreateTripNotifier extends _$CreateTripNotifier {
  String? _startDate;
  String? _endDate;
  String? _tripPlace;

  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> createTrip() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.watch(apiServiceProvider).createTrip(
          startDate: _startDate!, endDate: _endDate!, goingTo: _tripPlace!);
    });
  }
  Future<void> editTrip({required int tripId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.watch(apiServiceProvider).editTrip(
          startDate: _startDate!, endDate: _endDate!, id:tripId,goingTo: _tripPlace! );
    });
  }
  Future<void> deleteTrip({required int tripId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.watch(apiServiceProvider).deleteTrip(id: tripId);
    });
  }

  void updateForm(
      {required String startDate,
      required String endDate,
       String ?tripPlace}) {
    _startDate = startDate;
    _endDate = endDate;
    _tripPlace = tripPlace;
  }
}
