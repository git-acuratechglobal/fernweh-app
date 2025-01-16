import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/location_permission/location_service.dart';
import 'package:fernweh/view/navigation/explore/recommended/recommended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/widgets/async_widget.dart';
import '../map/restaurant_detail/restaurant_detail_screen.dart';
import 'current_location/current_location.dart';
import 'filter_sheet/filter_sheet.dart';
import 'friend_list/friend_list.dart';
import 'notifier/explore_notifier.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  int? selectedCategory;
String? selectedType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: const Color(0xffCF5253),
        edgeOffset: 60,
        onRefresh: () async {
        ref.invalidate(friendsItineraryNotifierProvider);
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: Config.backgroundGradient),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.paddingOf(context).top + 8),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top + 8,
                      left: 24,
                      right: 24),
                  child: Row(children: [
                    Image.asset('assets/images/location.png'),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CurrentLocation()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Location',
                              style: TextStyle(
                                color: Color(0xFF494D60),
                                fontSize: 12,
                              ),
                            ),
                            AsyncDataWidgetB(
                              dataProvider: addressProvider,
                              dataBuilder: ( data) {
                                return Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 230),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        data,
                                        style: TextStyle(
                                          color: const Color(0xFF1A1B28),
                                          fontVariations: FVariations.w700,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                        Icons.keyboard_arrow_down_outlined)
                                  ],
                                );
                              },
                              errorBuilder: (error, stack) => const Text("Unable to load location"),
                              loadingBuilder: const Skeletonizer(
                                child: Text("this is dummy location"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //           builder: (context) => const WishListScreen()),
                    //     );
                    //   },
                    //   icon: Image.asset(
                    //     'assets/images/heart.png',
                    //     color: const Color(0xffCF5253),
                    //   ),
                    // ),
                    Image.asset('assets/images/notification.png'),
                    // Container(
                    //   width: 70,
                    //   decoration: BoxDecoration(boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.1),
                    //       spreadRadius: 5,
                    //       blurRadius: 20,
                    //       offset: const Offset(0, 2),
                    //     ),
                    //   ]),
                    //   child:
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            constraints: BoxConstraints.tightFor(
                              height:
                                  MediaQuery.sizeOf(context).height * 0.88,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return FilterSheet(
                                refresh: (String val) {
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                        child: Image.asset('assets/images/filter.png')),

                    // ),
                  ]),
                ),
              ),
              const SizedBox(height: 26),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Categories',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1A1B28),
                      fontSize: 16,
                      fontVariations: FVariations.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox.fromSize(
                size: const Size.fromHeight(90),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 16.0);
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: Config.dashboardCategories.length,
                  itemBuilder: (context, index) {
                    final category = Config.dashboardCategories[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedCategory == index) {
                            selectedCategory = null;
                            selectedType=null;
                            ref
                                .read(
                                    friendsItineraryNotifierProvider.notifier)
                                .resetFilter();
                          } else {
                            selectedCategory = index;
                            selectedType=category.title;
                            ref
                                .read(
                                    friendsItineraryNotifierProvider.notifier)
                                .filterList(category.title.toLowerCase());
                          }
                        });

                        // if (category.title == mapViewState.selectedCategory) {
                        //   mapState.update(
                        //         categoryView: true,
                        //         itineraryView: false,
                        //         selectedCategory: "",
                        //       );
                        //   filterData = {
                        //     'type': null,
                        //     'rating': filters['rating'],
                        //     'radius': filters['radius'],
                        //     'sort_by': filters['sort_by'],
                        //     'selected_category': "All",
                        //     'selected_rating': filters['selected_rating'],
                        //     'selected_distance': filters['selected_distance'],
                        //     'selected_radius': filters['selected_radius'],
                        //     'input': filters['input'],
                        //     'search_term': filters['search_term'],
                        //   };
                        //   ref
                        //       .read(filtersProvider.notifier)
                        //       .updateFilter(filterData);
                        //   ref.invalidate(itineraryNotifierProvider);
                        //   return;
                        // } else {
                        //   mapState.update(
                        //         categoryView: true,
                        //         itineraryView: false,
                        //         selectedCategory: category.title,
                        //       );
                        //   filterData = {
                        //     'type': category.type,
                        //     'rating': filters['rating'],
                        //     'radius': filters['radius'],
                        //     'sort_by': filters['sort_by'],
                        //     'selected_category': category.title,
                        //     'selected_rating': filters['selected_rating'],
                        //     'selected_distance': filters['selected_distance'],
                        //     'selected_radius': filters['selected_radius'],
                        //     'input': filters['input'],
                        //     'search_term': filters['search_term'],
                        //   };
                        //   ref
                        //       .read(filtersProvider.notifier)
                        //       .updateFilter(filterData);
                        //   ref
                        //       .read(itineraryNotifierProvider
                        //       .notifier)
                        //       .filteredItinerary();
                        // }
                      },
                      child: CategoryItem(
                        category: category,
                        isSelected: selectedCategory == index,
                        // category.title == mapViewState.selectedCategory,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 34),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Friend list',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1A1B28),
                      fontSize: 16,
                      fontVariations: FVariations.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //****FriendList Widget ****
              const FriendList(),

              const SizedBox(height: 34),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Recommended for you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF1A1B28),
                      fontSize: 16,
                      fontVariations: FVariations.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AsyncDataWidgetB(
                  dataProvider: friendsItineraryNotifierProvider,
                  dataBuilder: ( category) {

                    return category.isFilterApplied &&
                            category.filterCategories.isEmpty
                        ? const Center(child: Text("No Itinerary Found"))
                        : category.categories.isEmpty
                            ? const Center(child: Text("No Itinerary Found"))
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: category.isFilterApplied
                                    ? category.filterCategories.length
                                    : category.categories.length,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12.0),
                                itemBuilder: (context, index) {
                                  final data = category.isFilterApplied
                                      ? category.filterCategories[index]
                                      : category.categories[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurantDetailScreen(
                                            types: data.type,
                                            address: data.vicinity,
                                            distance:
                                                data.distance.toString(),
                                            walkingTime: convertMinutes(
                                                int.parse(data.walkingTime
                                                    .toString())),
                                            images: data.photoUrls,
                                            name: data.name,
                                            rating: data.rating.toString(),
                                            locationId: data.placeId ?? "",
                                          ),
                                        ),
                                      );
                                    },
                                    child: RecommendedItem(
                                      address: data.vicinity.toString(),
                                      type: formatCategory(
                                          data.type ?? ["All"],selectedType),
                                      image: data.photoUrls!.isEmpty
                                          ? ""
                                          : data.photoUrls?[0],
                                      name: data.name,
                                      rating: data.rating.toString(),
                                      walkingTime: convertMinutes(int.parse(
                                          data.walkingTime.toString())),
                                      distance: data.distance.toString(),
                                      placeId: data.placeId,
                                    ),
                                  );
                                },
                              );
                  },
                  loadingBuilder: Skeletonizer(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12.0),
                      itemBuilder: (context, index) {
                        return const RecommendedItem(
                          address: "jkjljkljkl",
                          type: "cbcbcb",
                          image: "data.photo",
                          name: "data.name",
                          rating: " data.rating.toString()",
                          walkingTime: "data.walkingTime.toString()",
                          distance: "data.distance.toString()",
                        );
                      },
                    ),
                  ),
                  errorBuilder: (error, stack) =>
                      const Center(child: Text("No Itinerary Found"))),

              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
  });

  final bool isSelected;
  final ({IconData icon, String title, String type}) category;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xffE2E2E2)),
          ),
          child: Icon(
            category.icon,
            size: 26,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
        Text(
          category.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1A1B28),
          ),
        )
      ],
    );
  }
}

class FriendList extends ConsumerStatefulWidget {
  const FriendList({
    super.key,
  });

  @override
  ConsumerState<FriendList> createState() => _FriendListState();
}

class _FriendListState extends ConsumerState<FriendList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AsyncDataWidgetB<FriendsPlacesState>(
        dataProvider: friendsItineraryNotifierProvider,
        dataBuilder: ( category) {
          return category.isFilterApplied && category.filterList.isEmpty
              ? const Center(child: Text("No Itinerary Found"))
              : category.placesList.isEmpty
                  ? const Center(child: Text("No Itinerary Found"))
                  : SizedBox.fromSize(
                      size: Size.fromHeight(height * 0.32),
                      child: ListView.separated(
                        itemCount: category.isFilterApplied
                            ? category.filterList.length
                            : category.placesList.length,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12.0),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final data = category.isFilterApplied
                              ? category.filterList[index]
                              : category.placesList[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailScreen(
                                    image: data.photo,
                                    types: const [],
                                    walkingTime: convertMinutes(
                                        int.parse(data.walkingTime.toString())),
                                    distance: data.distance.toString(),
                                    address: data.formattedAddress,
                                    images: null,
                                    name: data.name,
                                    rating: data.rating.toString(),
                                    locationId: data.locationId ?? '',
                                  ),
                                ),
                              );
                            },
                            child: FriendsListItems(
                              ownerName: data.addedByName,
                              ownerImage: data.ownerImageUrl,
                              address: data.formattedAddress.toString(),
                              categoryName: data.placeTypes ?? "",
                              image: data.photo,
                              type: data.name,
                              name: data.name,
                              rating: data.rating.toString(),
                              walkingTime: convertMinutes(
                                  int.parse(data.walkingTime.toString())),
                              distance: data.distance.toString(),
                            ),
                          );
                        },
                      ),
                    );
        },
        loadingBuilder: Skeletonizer(
          child: SizedBox.fromSize(
            size: Size.fromHeight(height * 0.31),
            child: ListView.separated(
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              separatorBuilder: (context, index) => const SizedBox(width: 12.0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const FriendsListItems(
                  ownerName: "",
                  ownerImage: null,
                  address: "lklklklko",
                  categoryName: "jhjjhjj",
                  type: "data.name",
                  name: "data.name",
                  rating: "data.rating.toString()",
                  walkingTime: "data.walkingTime.toString()",
                );
              },
            ),
          ),
        ),
        errorBuilder: (error, stack) =>
            const Center(child: Text("No Itinerary Found")));
  }
}

class LocationRow extends StatelessWidget {
  const LocationRow({
    super.key,
    required this.address,
  });

  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Image.asset(
            'assets/images/location.png',
            color: const Color(0xFF505050),
          ),
        ),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            address,
            style: const TextStyle(
              color: Color(0xFF505050),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class DistanceRow extends StatelessWidget {
  const DistanceRow({
    super.key,
    this.walkingTime,
    this.distance,
  });

  final String? walkingTime;
  final String? distance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Image.asset(
            'assets/images/walk.png',
            color: const Color(0xFF505050),
          ),
        ),
        const SizedBox(width: 6.0),
        Expanded(
            child: walkingTime == null
                ? const Text(
                    "18 mins, 2.2 mi",
                    style: TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 12,
                    ),
                  )
                : Text(
                    "$walkingTime   $distance m.",
                    style: const TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 12,
                    ),
                  )),
      ],
    );
  }
}

class PeopleRow extends StatelessWidget {
  const PeopleRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Image.asset(
            'assets/images/graph.png',
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            '232 people recent visited',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

String convertMinutes(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  if (hours == 0) {
    return '$remainingMinutes minute${remainingMinutes != 1 ? 's' : ''}';
  }

  return '$hours hr${hours != 1 ? 's' : ''} and $remainingMinutes min${remainingMinutes != 1 ? 's' : ''}';
}

String formatCategory(List<String> categories,[String ?selectedType]) {
  if(selectedType!=null){
    if (categories.contains(selectedType.toLowerCase())) {
      String formattedType = selectedType.replaceAll('_', ' ');
      formattedType = formattedType
          .split(' ')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
      return formattedType;
    }else{
      return selectedType;
    }
  }
  String firstName = categories[0];

  firstName = firstName.replaceAll('_', ' ');

  firstName = firstName
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
  return firstName;
}
