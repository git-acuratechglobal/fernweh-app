import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/location_permission/location_service.dart';
import 'package:fernweh/view/navigation/explore/current_location/current_location.dart';
import 'package:fernweh/view/navigation/explore/recommended/recommended.dart';
import 'package:fernweh/view/navigation/explore/search_filter/search_and_filter_widget.dart';
import 'package:fernweh/view/navigation/explore/wish_list/wish_list_screen.dart';
import 'package:fernweh/view/navigation/map/notifier/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/widgets/async_widget.dart';
import '../map/model/category.dart';
import '../map/restaurant_detail/restaurant_detail_screen.dart';
import 'friend_list/friend_list.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  int? selectedIndex;
  Map<String, dynamic> filterData = {
    'type': null,
    'rating': null,
    'radius': null,
    'sort_by': null,
    'selected_category': null,
  };

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(filtersProvider);
    return Scaffold(
      body: RefreshIndicator(
        color: const Color(0xffCF5253),
        edgeOffset: 60,
        onRefresh: () async {
          ref.invalidate(addressProvider);
          ref.invalidate(itineraryNotifierProvider);
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: Config.backgroundGradient),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                dataBuilder: (BuildContext context, data) {
                                  return SizedBox(
                                    width: 190,
                                    child: Row(
                                      children: [
                                        Expanded(
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
                                    ),
                                  );
                                },
                                errorBuilder: (error, stack) => const Center(
                                  child:
                                      Text("Unable to load current location"),
                                ),
                                loadingBuilder: const Skeletonizer(
                                  child: Text("this is dummy location"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const WishListScreen()),
                          );
                        },
                        icon: Image.asset(
                          'assets/images/heart.png',
                          color: const Color(0xffCF5253),
                        ),
                      ),
                      Image.asset('assets/images/notification.png'),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),

                //****search and filter widget****
                SearchAndFilterWidget(
                  refresh: (String val) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 26),
                Padding(
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
                          if (category.title == filters['selected_category']) {
                            setState(() {
                              selectedIndex = -1;
                            });
                            filterData = {
                              'type': null,
                              'rating': filters['rating'],
                              'radius': filters['radius'],
                              'sort_by': filters['sort_by'],
                              'selected_category': "All",
                              'selected_rating': filters['selected_rating'],
                              'selected_distance': filters['selected_distance'],
                              'selected_radius': filters['selected_radius'],
                              'input': filters['input'],
                              'search_term': filters['search_term'],
                            };
                            ref
                                .read(filtersProvider.notifier)
                                .updateFilter(filterData);
                            return;
                          } else {
                            selectedIndex = index;
                            filterData = {
                              'type': category.type,
                              'rating': filters['rating'],
                              'radius': filters['radius'],
                              'sort_by': filters['sort_by'],
                              'selected_category': category.title,
                              'selected_rating': filters['selected_rating'],
                              'selected_distance': filters['selected_distance'],
                              'selected_radius': filters['selected_radius'],
                              'input': filters['input'],
                              'search_term': filters['search_term'],
                            };
                            ref
                                .read(filtersProvider.notifier)
                                .updateFilter(filterData);
                          }
                        },
                        child: CategoryItem(
                          category: category,
                          isSelected:
                              category.title == filters['selected_category'],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 34),
                Padding(
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
                const SizedBox(height: 16),

                //****FriendList Widget ****
                FriendList(
                  categoryName: filters['selected_category'] ?? "All",
                ),

                const SizedBox(height: 34),
                Padding(
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
                const SizedBox(height: 16),
                AsyncDataWidgetB(
                    dataProvider: itineraryNotifierProvider,
                    dataBuilder: (context, category) {
                      return category.isEmpty
                          ? const Center(child: Text("No Itinerary Found"))
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: category.length,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12.0),
                              itemBuilder: (context, index) {
                                final data = category[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailScreen(
                                          address: data.vicinity,
                                          distance: data.distance.toString(),
                                          walkingTime: convertMinutes(int.parse(
                                              data.walkingTime.toString())),
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
                                    type: formatCategory(data.type ?? ""),
                                    image: data.photoUrls!.isEmpty
                                        ? ""
                                        : data.photoUrls?[0],
                                    name: data.name,
                                    rating: data.rating.toString(),
                                    walkingTime: convertMinutes(
                                        int.parse(data.walkingTime.toString())),
                                    distance: data.distance.toString(),
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
    required this.categoryName,
  });

  final String categoryName;

  @override
  ConsumerState<FriendList> createState() => _FriendListState();
}

class _FriendListState extends ConsumerState<FriendList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AsyncDataWidgetB<List<Category>>(
        dataProvider: itineraryNotifierProvider,
        dataBuilder: (context, category) {
          return category.isEmpty
              ? const Center(child: Text("No Itinerary Found"))
              : SizedBox.fromSize(
                  size: Size.fromHeight(height * 0.31),
                  child: ListView.separated(
                    itemCount: category.length,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12.0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final data = category[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailScreen(
                                walkingTime: convertMinutes(
                                    int.parse(data.walkingTime.toString())),
                                distance: data.distance.toString(),
                                address: data.vicinity,
                                images: data.photoUrls,
                                name: data.name,
                                rating: data.rating.toString(),
                                locationId: data.placeId ?? '',
                              ),
                            ),
                          );
                        },
                        child: FriendsListItems(
                          address: data.vicinity.toString(),
                          categoryName: formatCategory(data.type ?? ""),
                          image:
                              data.photoUrls!.isEmpty ? "" : data.photoUrls?[0],
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

String formatCategory(String categories) {
  String firstName = categories.split('|').first;

  firstName = firstName.replaceAll('_', ' ');

  firstName = firstName
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  return firstName;
}


