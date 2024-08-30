class PlaceSearch {
  final String description;


  PlaceSearch({required this.description,});

  factory PlaceSearch.fromJson(Map<String,dynamic> json){
    return PlaceSearch(
        description: json['description'],

    );
  }
}