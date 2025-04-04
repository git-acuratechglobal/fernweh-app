import 'package:fernweh/services/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/trip/trip.dart';

part 'trip_notifier.g.dart';

@riverpod
Future<List<Trip>> getTrip(Ref ref) async {
  return await ref.watch(apiServiceProvider).getTrip()??[];
}

@riverpod
class TripDetail extends _$TripDetail {
  @override
  FutureOr<TripDetails?> build() async {
    return null;
  }

  Future<void> getTripDetails(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.watch(apiServiceProvider).getTripDetails(id: id);
    });
  }

  Future<void> getTripDetailsByLocation({String? homeLocation}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // String? fullAddress;
      // final currentPosition = await ref.read(currentPositionProvider.future);
      // final adress = await ref
      //     .watch(apiServiceProvider)
      //     .getPlaceIdFromCoordinates(currentPosition);
      // if (adress != null) {
      //    fullAddress = await ref
      //       .read(fullAddressNotifierProvider.notifier)
      //       .getFullAddress(placeId: adress);
      // }

      return ref
          .watch(apiServiceProvider)
          .getTripDetailsByLocation(address: homeLocation!);
    });
  }
}
