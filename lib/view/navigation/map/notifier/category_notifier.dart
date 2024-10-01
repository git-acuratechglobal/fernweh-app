import 'package:fernweh/services/api_service/api_service.dart';
import 'package:fernweh/view/location_permission/location_service.dart';
import 'package:fernweh/view/navigation/map/model/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:ui' as ui;

import '../state/map_view_state.dart';

part 'category_notifier.g.dart';

@Riverpod(keepAlive: true)
class ItineraryNotifier extends _$ItineraryNotifier {
  @override
  FutureOr<List<Category>> build() async {
    // final position = await ref.watch(currentPositionProvider.future);
    // final filters = ref.watch(filtersProvider);
    // final data = await ref.watch(apiServiceProvider).getCategory(
    //     position.latitude.toString(), position.longitude.toString(),
    //     filter: filters);
    // if (data.isNotEmpty) {
    //   ref.read(latlngProvider.notifier).state = LatLng(
    //       double.parse(data[0].latitude.toString()),
    //       double.parse(data[0].longitude.toString()));
    // }
    ref.invalidate(latlngProvider);
    return [];
  }

  Future<void> filteredItinerary() async {
    print("filter method called===================");
    try {
      state = const AsyncLoading();
      final position = await ref.watch(currentPositionProvider.future);
      final filters = ref.watch(filtersProvider);
      final data = await ref.watch(apiServiceProvider).getCategory(
          position.latitude.toString(), position.longitude.toString(),
          filter: filters);
      if (data.isNotEmpty) {
        ref.read(latlngProvider.notifier).state = LatLng(
            double.parse(data[0].latitude.toString()),
            double.parse(data[0].longitude.toString()));
      }else{
        ref.invalidate(latlngProvider);
      }
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final bitmapIconProvider =
    FutureProvider<BitmapDescriptor>((ref) async {

  ByteData data = await rootBundle.load("assets/images/marker_in_black.png");
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth:160,);
  ui.FrameInfo fi = await codec.getNextFrame();
  final Uint8List? markerIcon =
      (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
  return BitmapDescriptor.fromBytes(markerIcon!);
});

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<String, dynamic>>(
        (ref) => FilterNotifier());

class FilterNotifier extends StateNotifier<Map<String, dynamic>> {
  FilterNotifier()
      : super({
          // 'type': null,
          // 'rating': null,
          // 'radius': null,
          // 'sort_by': null,
          // 'selected_category': null,
          // 'selected_radius': null,
          // 'input': null
        });

  void updateFilter(Map<String, dynamic> filters) {
    state = filters;
  }
}

final searchControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());

final latlngProvider = StateProvider<LatLng?>((ref) => null);


final mapViewStateProvider = StateProvider<MapViewState>((ref) => MapViewState(categoryView: true,itineraryView: false));


