import 'package:fernweh/view/navigation/map/state/map_filter.dart';
import 'package:fernweh/view/navigation/map/state/map_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_notifier.g.dart';

@riverpod
class MapNotifier extends _$MapNotifier {
  @override
  FutureOr<MapState> build() async {
    return MapState(
        categoryList: [], itineraryPlaces: [], mapFilter: MapFilter());
  }

  Future<void> getCategoryPlaces() async {}
}
