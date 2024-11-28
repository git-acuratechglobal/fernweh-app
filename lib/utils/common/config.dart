import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
printLog(String message) {
  if (kDebugMode) {
    return debugPrint(message);
  }
}
abstract class Config {
  static LinearGradient backgroundGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffEEF4FE),
      Color(0xffFBEBEC),
    ],
  );

  static List<({String image, String title})> categories = [
    (image: 'assets/images/restaurant.png', title: "Restaurant"),
    (image: 'assets/images/bars.png', title: "Bars"),
    (image: 'assets/images/entertainment.png', title: "Entertainment"),
    (image: 'assets/images/attractions.png', title: "Attractions"),
  ];

  static List<({String image, String title})> categoriesOption = [
    (image: 'assets/images/attractions.png', title: "Domestic"),
    (image: 'assets/images/bars.png', title: "International"),
  ];

  static List<({String? image, String title, XFile? photo})> myItiratons = [
    (
      image: 'assets/images/london.png',
      title: "London Best Places",
      photo: null
    ),
    (image: 'assets/images/paris.png', title: "Paris Diaries", photo: null),
    (image: 'assets/images/tokyo.png', title: "Tokyo Fav Places", photo: null),
    (image: 'assets/images/iceland.png', title: "Iceland", photo: null),
  ];

  static List<({IconData icon, String title, String type})>
      dashboardCategories = [
    (
      icon: Icons.restaurant,
      title: "Restaurant",
      type: "restaurant|bakery|meal_delivery|meal_takeaway"
    ),
    (icon: Icons.coffee, title: "Cafe", type: "cafe"),
    (icon: Icons.wine_bar, title: "Bar", type: "bar|night_club|liquor_store"),
    (icon: Icons.movie, title: "Theater", type: "movie_theater"),
    (
      icon: Icons.attractions,
      title: "Attractions",
      type: "amusement_park|art_gallery|tourist_attraction|park||museum"
    ),
  ];

  static List<({String name, int id})> itinaryOptions = [
    (name: "Want to visit", id: 1),
    (name: "Visited", id: 2),
    (name: "Visited & Liked", id: 3),
  ];

  static List<String> tabOptions = [
    "All",
    "Want to visit",
    "Visited",
    "Visited & Liked",
  ];

  static List<({String image, String title})> onboarding = [
    (
      title: "Find the best\nplaces for you.",
      image: 'assets/images/onboarding0.jpg'
    ),
    (title: "Discover new things", image: 'assets/images/onboarding1.jpg'),
    (title: "Share your moments", image: 'assets/images/onboarding2.jpg'),
  ];

  static List<String> selectionOptions = [
    "Want to visit",
    "Visited",
    "Visited & Liked",
  ];

  static List<String> sortBy = [
    "Friends List",
    "Relevance",
    "Trending places",
    "Most Visited",
  ];

  static List<({String image, String title})> users = [
    (image: 'assets/images/avatar1.png', title: "Robert Clues"),
    (image: 'assets/images/avatar2.png', title: "Maria Jenny"),
    (image: 'assets/images/avatar3.png', title: "Ronald Roni")
  ];

  static List<({String? image, String type})> friendList = [
    (
      image:
          'https://assets.architecturaldigest.in/photos/64f84cc61d4896b633fba77a/master/w_1600%2Cc_limit/The%2520art%2520deco%2520inspired%2520de%25CC%2581cor%2520of%2520CIRQA%25201960%2520.jpg',
      type: 'Restaurant'
    ),
    (image: null, type: 'Cafe'),
    (
      image:
          'https://assets.cntraveller.in/photos/633d574c470d9a1e7cfb43da/3:2/w_6090,h_4060,c_limit/Paradiso_photo_bar4-oct22-pr.jpg',
      type: 'Bars'
    ),
    (
      image:
          'https://akm-img-a-in.tosshub.com/businesstoday/images/story/202301/cinema_0-sixteen_nine.jpg',
      type: 'Entertainment'
    ),
    (
      image:
          'https://www.trawell.in/blog/wp-content/uploads/2016/10/IndiaBlog_Main-730x410.jpg',
      type: 'Attractions'
    ),
    (
      image:
          'https://assets.architecturaldigest.in/photos/64f84cc61d4896b633fba77a/master/w_1600%2Cc_limit/The%2520art%2520deco%2520inspired%2520de%25CC%2581cor%2520of%2520CIRQA%25201960%2520.jpg',
      type: 'Restaurant'
    ),
    (image: null, type: 'Cafe'),
    (
      image:
          'https://assets.cntraveller.in/photos/633d574c470d9a1e7cfb43da/3:2/w_6090,h_4060,c_limit/Paradiso_photo_bar4-oct22-pr.jpg',
      type: 'Bars'
    ),
    (
      image:
          'https://akm-img-a-in.tosshub.com/businesstoday/images/story/202301/cinema_0-sixteen_nine.jpg',
      type: 'Entertainment'
    ),
    (
      image:
          'https://www.trawell.in/blog/wp-content/uploads/2016/10/IndiaBlog_Main-730x410.jpg',
      type: 'Attractions'
    ),
    (
      image:
          'https://assets.architecturaldigest.in/photos/64f84cc61d4896b633fba77a/master/w_1600%2Cc_limit/The%2520art%2520deco%2520inspired%2520de%25CC%2581cor%2520of%2520CIRQA%25201960%2520.jpg',
      type: 'Restaurant'
    ),
    (image: null, type: 'Cafe'),
    (
      image:
          'https://assets.cntraveller.in/photos/633d574c470d9a1e7cfb43da/3:2/w_6090,h_4060,c_limit/Paradiso_photo_bar4-oct22-pr.jpg',
      type: 'Bar'
    ),
    (
      image:
          'https://akm-img-a-in.tosshub.com/businesstoday/images/story/202301/cinema_0-sixteen_nine.jpg',
      type: 'Entertainment'
    ),
    (
      image:
          'https://www.trawell.in/blog/wp-content/uploads/2016/10/IndiaBlog_Main-730x410.jpg',
      type: 'Attractions'
    ),
  ];
  static List<({String name, String date})> tripList = [
    (name: "Tokyo", date: "10/11-15/11"),
    (name: "New York", date: "17/11-20/11"),
    (name: "Agra", date: "25/11-30/11"),
    (name: "USA", date: "10/11-15/11"),
    (name: "England", date: "17/11-20/11"),
    (name: "Japan", date: "25/11-30/11"),
  ];
}

final itineraryProvider = StateNotifierProvider<MyItiratons,
        List<({String? image, String title, XFile? photo})>>(
    (ref) => MyItiratons());

class MyItiratons
    extends StateNotifier<List<({String? image, String title, XFile? photo})>> {
  MyItiratons() : super(Config.myItiratons);

  void addItiratons({String? image, required String title, XFile? photo}) {
    final data = (image: image, title: title, photo: photo);
    state = [data, ...state];
  }
}

final filterListProvider =
    StateNotifierProvider<ExploreItems, ExploreState>((ref) => ExploreItems());

class ExploreItems extends StateNotifier<ExploreState> {
  ExploreItems()
      : super(ExploreState(
            itemList: Config.friendList,
            filterList: Config.friendList
                .where((e) => e.type == 'Restaurant')
                .toList()));

  void selectedCategoryItems(String? type) {
    final data = state;
    final filter = data.itemList.where((e) => e.type == type).toList();
    state = data.copyWith(filterList: filter);
  }

  void clearList() {
    state = state.copyWith(filterList: []);
  }
}

class ExploreState {
  List<({String? image, String type})> itemList;
  List<({String? image, String type})> filterList;

  ExploreState({required this.itemList, required this.filterList});

  ExploreState copyWith(
      {List<({String? image, String type})>? itemList,
      List<({String? image, String type})>? filterList}) {
    return ExploreState(
      itemList: itemList ?? this.itemList,
      filterList: filterList ?? this.filterList,
    );
  }
}
