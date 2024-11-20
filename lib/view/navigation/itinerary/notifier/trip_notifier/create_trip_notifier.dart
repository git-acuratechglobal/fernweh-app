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

  void updateForm(
      {required String startDate,
      required String endDate,
      required String tripPlace}) {
    _startDate = startDate;
    _endDate = endDate;
    _tripPlace = tripPlace;
  }
}
