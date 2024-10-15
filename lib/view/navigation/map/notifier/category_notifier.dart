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


/////*************THIS IS USED FOR MAP SCREEN DATA PROVIDER *****************////////////
@Riverpod(keepAlive: true)
class ItineraryNotifier extends _$ItineraryNotifier {
  @override
  FutureOr<List<Category>> build() async {
    ref.invalidate(latlngProvider);
    return [];
  }

  Future<void> filteredItinerary() async {
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
      } else {
        ref.invalidate(latlngProvider);
      }
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

////**********MAP MARKER SHOW PROVIDER********************
final bitmapIconProvider = FutureProvider<BitmapDescriptor>((ref) async {
  ByteData data = await rootBundle.load("assets/images/location-pin.png");
  ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: 100,
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  final Uint8List? markerIcon =
      (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
  return BitmapDescriptor.fromBytes(markerIcon!);
});

////**********ON MAP SCREEN FILTER TAB PROVIDER********************
final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<String, dynamic>>(
        (ref) => FilterNotifier());

class FilterNotifier extends StateNotifier<Map<String, dynamic>> {
  FilterNotifier()
      : super(
            {}); ////INITIAL FILTER IS NULL SO WE NOT HAVE TO SHOW PLACES BASED ON FILTER

  void updateFilter(Map<String, dynamic> filters) {
    state = filters;
    print(state);
  }
}

////////***********SEARCH PROVIDER FOR SEARCH PLACES****************//////////
final searchControllerProvider =
    StateProvider<TextEditingController>((ref) => TextEditingController());

////////***********LATLNG PROVIDER FOR INITIAL CAMERA POSITION WHEN DATA SHOW ON MAP  ****************
final latlngProvider = StateProvider<LatLng?>((ref) => null);

////////*********** THIS IS USED FOR FILTER AND MAP SCREEN STATE LIKE WHEN WE HAVE TO SHOW DATA FILTER OR ITINERARY PLACES ****************
class MapViewNotifier extends StateNotifier<MapViewState> {
  MapViewNotifier()
      : super(MapViewState(
            categoryView: true,
            itineraryView: false,
            selectedCategory: "null"));

  void update({
    String? selectedCategory,
    int? selectedItinerary,
    bool? categoryView,
    bool? itineraryView,
  }) {
    state = state.copyWith(
      selectedCategory: selectedCategory,
      selectedItinerary: selectedItinerary,
      categoryView: categoryView,
      itineraryView: itineraryView,
    );
  }
}

final mapViewStateProvider =
    StateNotifierProvider<MapViewNotifier, MapViewState>(
        (ref) => MapViewNotifier());
