import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fernweh/utils/common/action_button.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/view/navigation/map/notifier/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/common/config.dart';
import '../../../utils/common/extensions.dart';
import '../../../utils/widgets/loading_widget.dart';
import '../../location_permission/location_service.dart';
import '../explore/current_location/current_location.dart';
import '../explore/explore_screen.dart';
import '../explore/recommended/recommended.dart';
import '../explore/search_filter/search_and_filter_widget.dart';
import '../explore/wish_list/wish_list_screen.dart';
import 'model/category.dart';
import 'restaurant_detail/restaurant_detail_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool mapView = true;
  bool _isHide = true;
  int? selectedIndex = 0;
  List<Marker> markers = <Marker>[];
  late GoogleMapController mapController;

  Map<String, dynamic> filterData = {
    'type': null,
    'rating': null,
    'radius': null,
    'sort_by': null,
    'selected_category': null,
  };

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon =
        ref.watch(bitmapIconProvider(MediaQuery.devicePixelRatioOf(context)));
    final filters = ref.watch(filtersProvider);
    final currentPosition = ref.watch(positionProvider);
    final latLag = ref.watch(latlngProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        child: ActionButton(
          value: mapView,
          onPressed: () {
            setState(() {
              mapView = !mapView;
            });
            _customInfoWindowController.hideInfoWindow!();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
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
                  right: 24,
                ),
                child: Row(children: [
                  Image.asset('assets/images/location.png'),
                  const SizedBox(width: 8.0),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CurrentLocation()));
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
                                  const Icon(Icons.keyboard_arrow_down_outlined)
                                ],
                              ),
                            );
                          },
                          loadingBuilder: const Skeletonizer(
                            child: Text("this is dummy location"),
                          ),
                          errorBuilder: (error, stack) => const Center(
                            child: Text('Unable to load current location'),
                          ),
                        )
                      ],
                    ),
                  )),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const WishListScreen()),
                      );
                    },
                    icon: Image.asset('assets/images/un_heart.png'),
                  ),
                  Image.asset('assets/images/notification.png'),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(builder: (context, snapshot) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Visibility.maintain(
                          visible: mapView,
                          child: AsyncDataWidgetB(
                              dataProvider: itineraryNotifierProvider,
                              dataBuilder: (BuildContext context, category) {
                                markers.clear();
                                for (var data in category) {
                                  markers.add(Marker(
                                      icon: icon.value ??
                                          BitmapDescriptor.defaultMarker,
                                      consumeTapEvents: true,
                                      markerId:
                                          MarkerId(data.placeId.toString()),
                                      position: LatLng(
                                        double.parse(data.latitude.toString()),
                                        double.parse(data.longitude.toString()),
                                      ),
                                      onTap: () async {
                                        final latlng = LatLng(
                                          double.parse(
                                              data.latitude.toString()),
                                          double.parse(
                                              data.longitude.toString()),
                                        );
                                        await mapController
                                            .animateCamera(
                                                CameraUpdate.newLatLng(latlng))
                                            .then((val) {
                                          navigateToScreen(data);
                                        });
                                        setState(() {
                                          _isHide = false;
                                        });
                                      }));
                                }

                                return GoogleMap(
                                  myLocationButtonEnabled: false,
                                  myLocationEnabled: true,
                                  onMapCreated: (controller) async {
                                    mapController = controller;
                                    _customInfoWindowController
                                        .googleMapController = controller;
                                    final latlng = LatLng(
                                      double.parse(
                                          category[0].latitude.toString()),
                                      double.parse(
                                          category[0].longitude.toString()),
                                    );
                                    await mapController.animateCamera(
                                        CameraUpdate.newLatLng(latlng));
                                  },
                                  onTap: (controller) {
                                    setState(() {
                                      _isHide = !_isHide;
                                    });
                                    _customInfoWindowController
                                        .hideInfoWindow!();
                                  },
                                  initialCameraPosition: CameraPosition(
                                    zoom: 14,
                                    target: latLag == null
                                        ? LatLng(currentPosition.latitude,
                                            currentPosition.longitude)
                                        : LatLng(
                                            latLag.latitude, latLag.longitude),
                                  ),
                                  markers: Set.from(markers),
                                  onCameraMove: (position) {
                                    _customInfoWindowController.onCameraMove!();
                                  },
                                );
                              },
                              loadingBuilder: Stack(
                                children: [
                                  GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      zoom: 14.4746,
                                      target: LatLng(currentPosition!.latitude,
                                          currentPosition.longitude),
                                    ),
                                  ),
                                  const Scaffold(
                                    backgroundColor: Colors.black54,
                                    body: Center(child: LoadingWidget()),
                                  )
                                ],
                              ),
                              errorBuilder: (error, stack) => const SizedBox())),
                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: 70,
                      width: 220,
                      offset: 5,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///search widget
                          SearchAndFilterWidget(
                            refresh: (String val) {
                              setState(() {});
                            },
                          ),

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 56,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final category =
                                    Config.dashboardCategories[index];
                                return RawChip(
                                  backgroundColor: category.title ==
                                          filters['selected_category']
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  onPressed: () {
                                    if (category.title ==
                                        filters['selected_category']) {
                                      setState(() {
                                        selectedIndex = -1;
                                      });
                                      filterData = {
                                        'type': null,
                                        'rating': filters['rating'],
                                        'radius': filters['radius'],
                                        'sort_by': filters['sort_by'],
                                        'selected_category': "All",
                                        'selected_rating':
                                            filters['selected_rating'],
                                        'selected_distance':
                                            filters['selected_distance'],
                                        'selected_radius':
                                            filters['selected_radius'],
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
                                        'selected_rating':
                                            filters['selected_rating'],
                                        'selected_distance':
                                            filters['selected_distance'],
                                        'selected_radius':
                                            filters['selected_radius'],
                                        'input': filters['input'],
                                        'search_term': filters['search_term'],
                                      };
                                      ref
                                          .read(filtersProvider.notifier)
                                          .updateFilter(filterData);
                                    }

                                    _customInfoWindowController
                                        .hideInfoWindow!();
                                  },
                                  avatar: Icon(
                                    category.icon,
                                    color: category.title ==
                                            filters['selected_category']
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                        color: Color(0xffE2E2E2)),
                                  ),
                                  label: Text(
                                    category.title,
                                    style: TextStyle(
                                        color: category.title ==
                                                filters['selected_category']
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 6.0);
                              },
                              itemCount: Config.dashboardCategories.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!mapView)
                      Positioned.fill(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 120),
                            child: AsyncDataWidgetB(
                                dataProvider: itineraryNotifierProvider,
                                dataBuilder: (BuildContext context, category) {
                                  return ListView.separated(
                                    itemCount: category.length,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
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
                                                distance:
                                                    data.distance.toString(),
                                                walkingTime: convertMinutes(
                                                    int.parse(data.walkingTime
                                                        .toString())),
                                                address: data.vicinity,
                                                images: data.photoUrls!.isEmpty
                                                    ? [""]
                                                    : data.photoUrls,
                                                name: data.name,
                                                rating: data.rating.toString(),
                                                locationId: data.placeId ?? "",
                                              ),
                                            ),
                                          );
                                        },
                                        child: RecommendedItem(
                                          address: data.vicinity ?? "",
                                          type: formatCategory(data.type??""),
                                          image: data.photoUrls!.isEmpty
                                              ? ""
                                              : data.photoUrls?[0],
                                          name: data.name,
                                          distance: data.distance.toString(),
                                          walkingTime: convertMinutes(int.parse(
                                              data.walkingTime.toString())),
                                          rating: data.rating.toString(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                loadingBuilder: Skeletonizer(
                                  child: ListView.separated(
                                    itemCount: 3,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12.0),
                                    itemBuilder: (context, index) {
                                      return const RecommendedItem(
                                        address: "hkjkhjh",
                                        type: "data.name",
                                        image: " data.phot",
                                        name: "data.name",
                                        distance: "data.distance.toString()",
                                        rating: "data.rating.toString()",
                                      );
                                    },
                                  ),
                                ),
                                errorBuilder: (error, stack) => const Center(
                                    child: Text("No Itinerary Found")))),
                      )
                    else
                      _isHide
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 80),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: AspectRatio(
                                    aspectRatio: 2.7,
                                    child: AsyncDataWidgetB(
                                        key: ValueKey(selectedIndex),
                                        dataProvider: itineraryNotifierProvider,
                                        dataBuilder:
                                            (BuildContext context, category) {
                                          return ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: category.length,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 12.0),
                                            itemBuilder: (context, index) {
                                              final data = category[index];
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RestaurantDetailScreen(
                                                        distance: data.distance
                                                            .toString(),
                                                        walkingTime:
                                                            convertMinutes(
                                                                int.parse(data
                                                                    .walkingTime
                                                                    .toString())),
                                                        address: data.vicinity,
                                                        images: data.photoUrls!
                                                                .isEmpty
                                                            ? [""]
                                                            : data.photoUrls,
                                                        name: data.name,
                                                        rating: data.rating
                                                            .toString(),
                                                        locationId:
                                                            data.placeId ?? "",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: SizedBox(
                                                  width: 330,
                                                  child: RecommendedItem(
                                                    address:
                                                        data.vicinity ?? "",
                                                    type: formatCategory(data.type??""),
                                                    image: data
                                                            .photoUrls!.isEmpty
                                                        ? ""
                                                        : data.photoUrls?[0],
                                                    name: data.name,
                                                    distance: data.distance
                                                        .toString(),
                                                    walkingTime: convertMinutes(
                                                        int.parse(data
                                                            .walkingTime
                                                            .toString())),
                                                    rating:
                                                        data.rating.toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        loadingBuilder: Skeletonizer(
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 3,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 12.0),
                                            itemBuilder: (context, index) {
                                              return const SizedBox(
                                                width: 400,
                                                child: RecommendedItem(
                                                  address: "hkjkhjh",
                                                  type: "data.name",
                                                  image: " data.phot",
                                                  name: "data.name",
                                                  distance:
                                                      "data.distance.toString()",
                                                  rating:
                                                      "data.rating.toString()",
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        errorBuilder: (error, stack) =>
                                            const Center(
                                                child: Text(
                                                    "No Itinerary Found")))),
                              ),
                            )
                          : const SizedBox.shrink()
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void navigateToScreen(Category data) {
    _customInfoWindowController.addInfoWindow!(
        MarkerInfo(
          data: data,
        ),
        LatLng(double.parse(data.latitude.toString()),
            double.parse(data.longitude.toString())));
  }
}

class MarkerInfo extends StatelessWidget {
  const MarkerInfo({super.key, required this.data});

  final Category data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              distance: data.distance.toString(),
              walkingTime:
                  convertMinutes(int.parse(data.walkingTime.toString())),
              address: data.vicinity,
              images: data.photoUrls!.isEmpty ? [""] : data.photoUrls,
              name: data.name,
              rating: data.rating.toString(),
              locationId: data.placeId ?? "",
            ),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x661A1B28),
              blurRadius: 24,
              offset: Offset(0, 12),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              height: 70,
              width: 80,
              child: CachedNetworkImage(
                  imageUrl: data.photoUrls!.isEmpty ? "" : data.photoUrls![0],
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(child: LoadingWidget()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                      overflow: TextOverflow.ellipsis,
                      data.name.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Color(0xffF4CA12),
                    ),
                    data.rating == null
                        ? const Text(
                            "0",
                            style: TextStyle(fontSize: 12),
                          )
                        : Text(
                            data.rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
