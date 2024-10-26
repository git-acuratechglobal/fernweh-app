class MapFilter {
  String? selectedCategory;
  String? selectedItinerary;
  String? rating;
  double? radius;
  String? searchTerm;
  String? input;

  MapFilter(
      {this.selectedCategory,
      this.selectedItinerary,
      this.rating,
      this.radius,
      this.searchTerm,
      this.input});

  MapFilter copyWith(
      {String? selectedCategory,
      String? selectedItinerary,
      String? rating,
      double? radius,
      String? searchTerm,
      String? input}) {
    return MapFilter(
      selectedCategory: this.selectedCategory ?? selectedCategory,
      selectedItinerary: this.selectedItinerary ?? selectedItinerary,
      rating: this.rating ?? rating,
      radius: this.radius ?? radius,
      searchTerm: this.searchTerm ?? searchTerm,
      input: this.input ?? input,
    );
  }
  MapFilter clear() {
    return MapFilter();
  }
}
