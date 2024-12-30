import '../../collections/models/itinerary_places.dart';
import '../model/category.dart';
import 'map_filter.dart';

class MapState {
  List<Category> categoryList;
  List<ItineraryPlaces> itineraryPlaces;
  MapFilter mapFilter;

  MapState(
      {required this.categoryList,
      required this.itineraryPlaces,
       required this.mapFilter});
}
