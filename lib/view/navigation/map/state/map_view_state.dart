class MapViewState {
  String? selectedCategory;
  int? selectedItinerary;
  bool categoryView;
  bool itineraryView;

  MapViewState(
      {this.selectedCategory,
      this.selectedItinerary,
     required this.categoryView ,
    required  this.itineraryView});

  MapViewState copyWith({
    String? selectedCategory,
    int? selectedItinerary,
    bool? categoryView,
    bool? itineraryView,
  }) {
    return MapViewState(
        selectedCategory: selectedCategory ?? this.selectedCategory,
        selectedItinerary: selectedItinerary ?? this.selectedItinerary,
        categoryView: categoryView ?? this.categoryView,
        itineraryView: itineraryView ?? this.itineraryView);
  }
}
