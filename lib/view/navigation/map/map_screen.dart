import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/view/navigation/explore/wish_list/wish_list_screen.dart';
import 'package:fernweh/view/navigation/map/notifier/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/common/widgets.dart';
import '../../../utils/widgets/loading_widget.dart';
import '../../location_permission/location_service.dart';
import '../explore/explore_screen.dart';
import '../explore/recommended/recommended.dart';
import '../explore/search_filter/search_and_filter_widget.dart';
import '../itinerary/models/itinerary_model.dart';
import '../itinerary/models/itinerary_places.dart';
import '../itinerary/notifier/itinerary_notifier.dart';
import 'model/category.dart';
import 'restaurant_detail/restaurant_detail_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {

  bool _categoryMapView = true;
  bool _itineraryMapView = true;
  bool itemsHide = false;
  int? selectedItineraryIndex;
  List<Marker> markers = <Marker>[];
  String? selectedPlaceId;
  late GoogleMapController mapController;
  late ScrollController _scrollController;
  bool floatingButtonsHide = true;

  Map<String, dynamic> filterData = {};
  bool showSearchMessage = false;
  LatLng? _latLng;

  void searchMessage() {
    Position position = Position(
        latitude: _latLng!.latitude,
        longitude: _latLng!.longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0);
    ref.read(currentPositionProvider.notifier).updatePosition(position);
    setState(() {
      floatingButtonsHide = false;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = ref.watch(bitmapIconProvider);
    final filters = ref.watch(filtersProvider);
    final currentPosition = ref.watch(positionProvider);
    final latLag = ref.watch(latlngProvider);
    final mapViewState = ref.watch(mapViewStateProvider);
    final mapState = ref.read(mapViewStateProvider.notifier);
    // print(mapViewState.itineraryView);
    // print(mapViewState.categoryView);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: mapViewState.categoryView
      //     ? SizedBox(
      //         height: 50,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             const SizedBox(),
      //
      //             ///***when no filter is applied then we have to hide floating button
      //             mapViewState.selectedCategory == "null"
      //                 ? const SizedBox.shrink()
      //                 : ActionButton(
      //                     value: _categoryMapView,
      //                     onPressed: () {
      //                       setState(() {
      //                         _categoryMapView = !_categoryMapView;
      //                       });
      //                       // _customInfoWindowController.hideInfoWindow!();
      //                     },
      //                   ),
      //             Padding(
      //               padding: const EdgeInsets.only(right: 10),
      //               child: Container(
      //                 decoration: const BoxDecoration(
      //                     color: Colors.white, shape: BoxShape.circle),
      //                 child: IconButton(
      //                   onPressed: () async {
      //                     ref.invalidate(currentPositionProvider);
      //                     ref.invalidate(mapViewStateProvider);
      //                     ref.invalidate(itineraryNotifierProvider);
      //                     setState(() {
      //                       floatingButtonsHide = true;
      //                     });
      //                   },
      //                   icon: const Icon(Icons.gps_fixed_outlined),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       )
      //     : SizedBox(
      //         height: 50,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             const SizedBox(),
      //             floatingButtonsHide
      //                 ? const SizedBox.shrink()
      //                 : ActionButton(
      //                     value: _itineraryMapView,
      //                     onPressed: () {
      //                       setState(() {
      //                         _itineraryMapView = !_itineraryMapView;
      //                       });
      //                       // _customInfoWindowController.hideInfoWindow!();
      //                     },
      //                   ),
      //             Padding(
      //               padding: const EdgeInsets.only(right: 10),
      //               child: Container(
      //                 decoration: const BoxDecoration(
      //                     color: Colors.white, shape: BoxShape.circle),
      //                 child: IconButton(
      //                   onPressed: () {
      //                     ref.invalidate(currentPositionProvider);
      //                     ref.invalidate(mapViewStateProvider);
      //                     ref.invalidate(itineraryNotifierProvider);
      //                   },
      //                   icon: const Icon(Icons.gps_fixed_outlined),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const CurrentLocation()));
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
                                const Icon(Icons.keyboard_arrow_down_outlined)
                              ],
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
                  GestureDetector(
                    onTap: (){
                      context.navigateTo(const WishListScreen());
                    },
                    child: Image.asset(
                      'assets/images/heart.png',
                      color: const Color(0xffCF5253),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/notification.png'),
                ]),
              ),
            ),
            const SizedBox(height: 16),

            ///*** this map widget is used when we press on categories list then marker show of categories list

            Expanded(
              child: LayoutBuilder(builder: (context, snapshot) {
                return Stack(
                  children: [
                    if (mapViewState.categoryView)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Visibility.maintain(
                            visible: _categoryMapView,
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
                                          double.parse(
                                              data.latitude.toString()),
                                          double.parse(
                                              data.longitude.toString()),
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
                                                  CameraUpdate.newLatLng(
                                                      latlng))
                                              .then((val) {
                                            // navigateToScreen(data);
                                          });
                                          setState(() {
                                            // itemsHide = true;
                                            _scrollToSelectedPlace(category,
                                                data.placeId.toString());
                                            selectedPlaceId = data.placeId;
                                          });
                                        }));
                                  }

                                  return GoogleMap(
                                    zoomControlsEnabled: false,
                                    myLocationButtonEnabled: false,
                                    myLocationEnabled: true,
                                    onMapCreated: (controller) async {
                                      mapController = controller;
                                      if (category.isNotEmpty) {
                                        final latlng = LatLng(
                                          double.parse(
                                              category[0].latitude.toString()),
                                          double.parse(
                                              category[0].longitude.toString()),
                                        );
                                        await mapController.animateCamera(
                                            CameraUpdate.newLatLng(latlng));
                                      } else {
                                        await mapController.animateCamera(
                                            CameraUpdate.newLatLng(
                                          LatLng(currentPosition!.latitude,
                                              currentPosition.longitude),
                                        ));
                                      }
                                    },
                                    onTap: (controller) {
                                      setState(() {
                                        itemsHide = !itemsHide;
                                      });
                                    },
                                    initialCameraPosition: CameraPosition(
                                      zoom: 14,
                                      target: latLag == null
                                          ? LatLng(currentPosition!.latitude,
                                              currentPosition.longitude)
                                          : LatLng(latLag.latitude,
                                              latLag.longitude),
                                    ),
                                    markers: Set.from(markers),
                                    onCameraMoveStarted: () {
                                      setState(() {
                                        showSearchMessage = true;
                                      });
                                    },
                                    onCameraMove: (position) {
                                      setState(() {
                                        _latLng = position.target;
                                      });
                                    },
                                  );
                                },
                                loadingBuilder: const Stack(
                                  children: [
                                    // GoogleMap(
                                    //   myLocationButtonEnabled: false,
                                    //   myLocationEnabled: false,
                                    //   initialCameraPosition: CameraPosition(
                                    //     zoom: 14.4746,
                                    //     target: LatLng(
                                    //         currentPosition!.latitude,
                                    //         currentPosition.longitude),
                                    //   ),
                                    // ),
                                    Scaffold(
                                      backgroundColor: Colors.black54,
                                      body: Center(child: LoadingWidget()),
                                    )
                                  ],
                                ),
                                errorBuilder: (error, stack) =>
                                    const SizedBox())),
                      ),

                    ///*** here we show map of itinerary list when we press on itinerary list then marker show of itinerary

                    if (mapViewState.itineraryView)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Visibility.maintain(
                          visible: _itineraryMapView,
                          child: AsyncDataWidgetB(
                            dataProvider: itineraryPlacesNotifierProvider,
                            dataBuilder:
                                (BuildContext context, itineraryPlace) {
                              markers.clear();
                              for (var data in itineraryPlace) {
                                markers.add(Marker(
                                    icon: icon.value ??
                                        BitmapDescriptor.defaultMarker,
                                    consumeTapEvents: true,
                                    markerId:
                                        MarkerId(data.locationId.toString()),
                                    position: LatLng(
                                      double.parse(data.latitude.toString()),
                                      double.parse(data.longitude.toString()),
                                    ),
                                    onTap: () async {
                                      final latlng = LatLng(
                                        double.parse(data.latitude.toString()),
                                        double.parse(data.longitude.toString()),
                                      );
                                      await mapController
                                          .animateCamera(
                                              CameraUpdate.newLatLng(latlng))
                                          .then((val) {
                                        // itineraryMarkerInfo(data);
                                      });
                                      setState(() {
                                        _scrollToSelectedItineraryPlace(
                                            itineraryPlace, data.id.toString());
                                        selectedPlaceId = data.id.toString();
                                      });
                                    }));
                              }

                              return GoogleMap(
                                zoomControlsEnabled: false,
                                myLocationButtonEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  zoom: 14.4746,
                                  target: latLag == null
                                      ? LatLng(currentPosition!.latitude,
                                          currentPosition.longitude)
                                      : LatLng(
                                          latLag.latitude, latLag.longitude),
                                ),
                                onMapCreated: (controller) async {
                                  mapController = controller;
                                  final latlng = LatLng(
                                    double.parse(
                                        itineraryPlace[0].latitude.toString()),
                                    double.parse(
                                        itineraryPlace[0].longitude.toString()),
                                  );
                                  await mapController.animateCamera(
                                      CameraUpdate.newLatLng(latlng));
                                },
                                onCameraMove: (position) async {},
                                onTap: (latLng) {
                                  setState(() {
                                    itemsHide = !itemsHide;
                                  });
                                },
                                markers: Set.from(markers),
                              );
                            },
                            errorBuilder: (e, st) => Center(
                              child: Text(e.toString()),
                            ),
                            loadingBuilder: const Stack(
                              children: [
                                // GoogleMap(
                                //   myLocationButtonEnabled: false,
                                //   myLocationEnabled: false,
                                //   initialCameraPosition: CameraPosition(
                                //     zoom: 14.4746,
                                //     target: LatLng(30.7333, 76.7794),
                                //   ),
                                // ),
                                Scaffold(
                                  backgroundColor: Colors.black45,
                                  body: Center(
                                    child: LoadingWidget(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    // CustomInfoWindow(
                    //   controller: _customInfoWindowController,
                    //   height: 70,
                    //   width: 220,
                    //   offset: 5,
                    // ),
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

                          ///*** this is category list

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
                                  backgroundColor: mapViewState
                                              .selectedCategory ==
                                          category.title
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  onPressed: () {
                                    if (mapViewState.selectedCategory ==
                                        category.title) {
                                      setState(() {
                                        floatingButtonsHide = true;
                                      });
                                      mapState.update(
                                          categoryView: true,
                                          itineraryView: false,
                                          selectedCategory: "null");
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
                                      ref.invalidate(itineraryNotifierProvider);

                                      return;
                                    } else {
                                      setState(() {
                                        floatingButtonsHide = false;
                                      });
                                      mapState.update(
                                          categoryView: true,
                                          itineraryView: false,
                                          selectedCategory: category.title,
                                          selectedItinerary: -1);
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
                                      ref
                                          .read(itineraryNotifierProvider
                                              .notifier)
                                          .filteredItinerary();
                                    }
                                  },
                                  avatar: Icon(
                                    category.icon,
                                    color: mapViewState.selectedCategory ==
                                            category.title
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
                                        color: mapViewState.selectedCategory ==
                                                category.title
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

                          ///*** here is the user itinerary list widget

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 36,
                            child: AsyncDataWidgetB(
                              dataProvider: getUserItineraryProvider,
                              dataBuilder: (context, itinerary) {
                                final List<Itenery> filteredList = itinerary
                                    .userIteneries!
                                    .where((e) => e.placesCount != 0)
                                    .toList();
                                return filteredList.isEmpty
                                    ? const SizedBox.shrink()
                                    : ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: filteredList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final userItinerary =
                                              filteredList[index].itinerary;
                                          return RawChip(
                                            onPressed: () {
                                              // setState(() {
                                              if (mapViewState
                                                      .selectedItinerary ==
                                                  index) {
                                                setState(() {
                                                  floatingButtonsHide = true;
                                                });
                                                mapState.update(
                                                    categoryView: true,
                                                    itineraryView: false,
                                                    selectedItinerary: -1);
                                                filterData = {
                                                  'type': null,
                                                  'rating': filters['rating'],
                                                  'radius': filters['radius'],
                                                  'sort_by': filters['sort_by'],
                                                  'selected_category': "All",
                                                  'selected_rating': filters[
                                                      'selected_rating'],
                                                  'selected_distance': filters[
                                                      'selected_distance'],
                                                  'selected_radius': filters[
                                                      'selected_radius'],
                                                  'input': filters['input'],
                                                  'search_term':
                                                      filters['search_term'],
                                                };
                                                ref
                                                    .read(filtersProvider
                                                        .notifier)
                                                    .updateFilter(filterData);
                                              } else {
                                                setState(() {
                                                  floatingButtonsHide = false;
                                                });
                                                mapState.update(
                                                    categoryView: false,
                                                    itineraryView: true,
                                                    selectedCategory: "null",
                                                    selectedItinerary: index);
                                                ref
                                                    .read(
                                                        itineraryPlacesNotifierProvider
                                                            .notifier)
                                                    .getItineraryPlaces(
                                                        userItinerary?.id ?? 0);
                                                // _itineraryView = true;
                                                // _categoryView = false;
                                              }
                                              // });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              side: const BorderSide(
                                                  color: Color(0xffE2E2E2)),
                                            ),
                                            backgroundColor: mapViewState
                                                        .selectedItinerary ==
                                                    index
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Colors.white,
                                            label: Text(
                                              userItinerary?.name ?? "",
                                              style: TextStyle(
                                                  color: mapViewState
                                                              .selectedItinerary ==
                                                          index
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(width: 6.0);
                                        },
                                      );
                              },
                              errorBuilder: (error, st) =>
                                  const SizedBox.shrink(),
                              loadingBuilder: Skeletonizer(
                                  enableSwitchAnimation: true,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 6,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return RawChip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: const BorderSide(
                                                color: Color(0xffE2E2E2)),
                                          ),
                                          label: const Text("dummy text"));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(width: 6.0);
                                    },
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          ///*** here is the logic that if category map is widget is showing then if user scrool the map then this message will show

                          if (_categoryMapView &&
                              mapViewState.categoryView &&
                              showSearchMessage)
                            GestureDetector(
                              onTap: () {
                                searchMessage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("search this area"),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),

                    ///*** here if itinerary widget is list view and view of screen is itinerary then this widget is show

                    if (!_itineraryMapView && mapViewState.itineraryView)
                      Positioned.fill(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 180),
                            child: AsyncDataWidgetB(
                                dataProvider: itineraryPlacesNotifierProvider,
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
                                                latitude: data.latitude,
                                                longitude: data.longitude,
                                                types: const [],
                                                distance:
                                                    data.distance.toString(),
                                                walkingTime: convertMinutes(
                                                    int.parse(data.walkingTime
                                                        .toString())),
                                                address: data.vicinity,
                                                image: data.photo,
                                                name: data.name,
                                                rating: data.rating.toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: RecommendedItem(
                                          address: data.vicinity ?? "",
                                          type: data.placeTypes,
                                          image: data.photo,
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
                      ),

                    ///*** if titinearay is map view then this widget show

                    if (_itineraryMapView && mapViewState.itineraryView)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AspectRatio(
                              aspectRatio: 2.7,
                              child: AsyncDataWidgetB(
                                  dataProvider: itineraryPlacesNotifierProvider,
                                  dataBuilder:
                                      (BuildContext context, category) {
                                    return ListView.separated(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: category.length,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 12.0),
                                      itemBuilder: (context, index) {
                                        final data = category[index];
                                        final bool isSelected =
                                            selectedPlaceId ==
                                                data.id.toString();
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RestaurantDetailScreen(
                                                  latitude: data.latitude,
                                                  longitude: data.longitude,
                                                  types: const [],
                                                  distance:
                                                      data.distance.toString(),
                                                  walkingTime: convertMinutes(
                                                      int.parse(data.walkingTime
                                                          .toString())),
                                                  address: data.vicinity,
                                                  image: data.photo,
                                                  name: data.name,
                                                  rating:
                                                      data.rating.toString(),
                                                ),
                                              ),
                                            );
                                            setState(() {
                                              selectedPlaceId =
                                                  data.id.toString();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: isSelected
                                                        ? Colors.redAccent
                                                        : Colors.transparent,
                                                    width: 2)),
                                            child: SizedBox(
                                              width: 330,
                                              child: RecommendedItem(
                                                address: data.vicinity ?? "",
                                                type: data.placeTypes,
                                                image: data.photo,
                                                name: data.name,
                                                distance:
                                                    data.distance.toString(),
                                                walkingTime: convertMinutes(
                                                    int.parse(data.walkingTime
                                                        .toString())),
                                                rating: data.rating.toString(),
                                              ),
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
                                      separatorBuilder: (context, index) =>
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
                                            rating: "data.rating.toString()",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  errorBuilder: (error, stack) => const Center(
                                      child: Text("No Itinerary Found")))),
                        ),
                      ),

                    ///*** if category view is list view
                    if (!_categoryMapView && mapViewState.categoryView)
                      Positioned.fill(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 180),
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
                                                latitude: data.latitude,
                                                longitude: data.longitude,
                                                types: data.type ?? [],
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
                                        child: SizedBox(
                                          height: 130,
                                          child: RecommendedItem(
                                            placeId: data.placeId,
                                            address: data.vicinity ?? "",
                                            type: formatCategory(
                                                data.type ?? ["All"]),
                                            image: data.photoUrls!.isEmpty
                                                ? ""
                                                : data.photoUrls?[0],
                                            name: data.name,
                                            distance: data.distance.toString(),
                                            walkingTime: convertMinutes(
                                                int.parse(data.walkingTime
                                                    .toString())),
                                            rating: data.rating.toString(),
                                          ),
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
                      ),

                    ///*** this widget show when category view is map view

                    if (_categoryMapView && mapViewState.categoryView)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AspectRatio(
                              aspectRatio: 2.7,
                              child: AsyncDataWidgetB(
                                  dataProvider: itineraryNotifierProvider,
                                  dataBuilder:
                                      (BuildContext context, category) {
                                    return category.isEmpty
                                        ? const SizedBox.shrink()
                                        : ListView.separated(
                                            controller: _scrollController,
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
                                              final bool isSelected0 =
                                                  selectedPlaceId ==
                                                      data.placeId;
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RestaurantDetailScreen(
                                                        latitude: data.latitude,
                                                        longitude:
                                                            data.longitude,
                                                        types: data.type ?? [],
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
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: isSelected0
                                                              ? Colors.redAccent
                                                              : Colors
                                                                  .transparent,
                                                          width: 2)),
                                                  child: SizedBox(
                                                    width: 330,
                                                    child: RecommendedItem(
                                                      placeId: data.placeId,
                                                      address:
                                                          data.vicinity ?? "",
                                                      type: formatCategory(
                                                          data.type ?? ["All"]),
                                                      image: data.photoUrls!
                                                              .isEmpty
                                                          ? ""
                                                          : data.photoUrls?[0],
                                                      name: data.name,
                                                      distance: data.distance
                                                          .toString(),
                                                      walkingTime:
                                                          convertMinutes(
                                                              int.parse(data
                                                                  .walkingTime
                                                                  .toString())),
                                                      rating: data.rating
                                                          .toString(),
                                                    ),
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
                                      separatorBuilder: (context, index) =>
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
                                            rating: "data.rating.toString()",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  errorBuilder: (error, stack) => const Center(
                                      child: Text("No Itinerary Found")))),
                        ),
                      ),
                    Positioned(
                      right: 0,
                      bottom: 180,
                      child: mapViewState.categoryView
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 05),
                            child: SizedBox(
                                child: Column(
                                  children: [
                                    _categoryMapView
                                        ? Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10,),
                                          child: Container(
                                            height: 40,
                                              width: 40,
                                              decoration:  BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: IconButton(
                                                onPressed: () async {
                                                  ref.invalidate(
                                                      currentPositionProvider);
                                                  ref.invalidate(
                                                      mapViewStateProvider);
                                                  ref.invalidate(
                                                      itineraryNotifierProvider);
                                                  setState(() {
                                                    floatingButtonsHide = true;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.gps_fixed_outlined),
                                              ),
                                            ),
                                        )
                                        : const SizedBox.shrink(),

                                    ///***when no filter is applied then we have to hide floating button
                                    mapViewState.selectedCategory == "null"
                                        ? const SizedBox.shrink()
                                        : SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: ActionButton(
                                              value: _categoryMapView,
                                              onPressed: () {
                                                setState(() {
                                                  _categoryMapView =
                                                      !_categoryMapView;
                                                });
                                                // _customInfoWindowController.hideInfoWindow!();
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                          )
                          : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 05),
                            child: SizedBox(
                                child: Column(
                                  children: [
                                    _itineraryMapView
                                        ? Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                              decoration:  BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,border: Border.all(color: Colors.grey)),
                                              child: IconButton(
                                                onPressed: () {
                                                  ref.invalidate(
                                                      currentPositionProvider);
                                                  ref.invalidate(
                                                      mapViewStateProvider);
                                                  ref.invalidate(
                                                      itineraryNotifierProvider);
                                                },
                                                icon: const Icon(
                                                    Icons.gps_fixed_outlined),
                                              ),
                                            ),
                                        )
                                        : const SizedBox.shrink(),
                                    floatingButtonsHide
                                        ? const SizedBox.shrink()
                                        : SizedBox(
                                      height: 40,
                                      width: 40,
                                            child: ActionButton(
                                              value: _itineraryMapView,
                                              onPressed: () {
                                                setState(() {
                                                  _itineraryMapView =
                                                      !_itineraryMapView;
                                                });
                                                // _customInfoWindowController.hideInfoWindow!();
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                          ),
                    )
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void _scrollToSelectedPlace(List<Category> category, String placeId) {
    final index = category.indexWhere((element) => element.placeId == placeId);

    if (index != -1) {
      _scrollController.animateTo(
        index * 342.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToSelectedItineraryPlace(
      List<ItineraryPlaces> itinerary, String placeId) {
    final index =
        itinerary.indexWhere((element) => element.id.toString() == placeId);

    if (index != -1) {
      _scrollController.animateTo(
        index * 342.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

// void navigateToScreen(Category data) {
//   _customInfoWindowController.addInfoWindow!(
//       MarkerInfo(
//         data: data,
//       ),
//       LatLng(double.parse(data.latitude.toString()),
//           double.parse(data.longitude.toString())));
// }
//
// void itineraryMarkerInfo(ItineraryPlaces data) {
//   _customInfoWindowController.addInfoWindow!(
//       ItineraryMarkersInfo(
//         data: data,
//       ),
//       LatLng(double.parse(data.latitude.toString()),
//           double.parse(data.longitude.toString())));
// }
}

// class MarkerInfo extends StatelessWidget {
//   const MarkerInfo({super.key, required this.data});
//
//   final Category data;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RestaurantDetailScreen(
//               distance: data.distance.toString(),
//               walkingTime:
//                   convertMinutes(int.parse(data.walkingTime.toString())),
//               address: data.vicinity,
//               images: data.photoUrls!.isEmpty ? [""] : data.photoUrls,
//               name: data.name,
//               rating: data.rating.toString(),
//               locationId: data.placeId ?? "",
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x661A1B28),
//               blurRadius: 24,
//               offset: Offset(0, 12),
//               spreadRadius: 0,
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               height: 70,
//               width: 80,
//               child: CachedNetworkImage(
//                   imageUrl: data.photoUrls!.isEmpty ? "" : data.photoUrls![0],
//                   progressIndicatorBuilder: (context, url, progress) =>
//                       const Center(child: LoadingWidget()),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                   fit: BoxFit.cover),
//             ),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 120,
//                   child: Text(
//                       overflow: TextOverflow.ellipsis,
//                       data.name.toString(),
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.star_rounded,
//                       size: 18,
//                       color: Color(0xffF4CA12),
//                     ),
//                     data.rating == null
//                         ? const Text(
//                             "0",
//                             style: TextStyle(fontSize: 12),
//                           )
//                         : Text(
//                             data.rating.toString(),
//                             style: const TextStyle(fontSize: 12),
//                           )
//                   ],
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PlacesSheet extends StatelessWidget {
//   const PlacesSheet(
//       {super.key, required this.scrollController, required this.categories});
//
//   final List<Category> categories;
//
//   final ScrollController scrollController;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       controller: scrollController,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               width: 40,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: const Color(0xffCDCFD0),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//         ListView.separated(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           itemCount: categories.length,
//           itemBuilder: (BuildContext context, int index) {
//             final category = categories[index];
//             return GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => RestaurantDetailScreen(
//                       distance: category.distance.toString(),
//                       walkingTime: convertMinutes(
//                           int.parse(category.walkingTime.toString())),
//                       address: category.vicinity,
//                       images: category.photoUrls!.isEmpty
//                           ? null
//                           : category.photoUrls,
//                       name: category.name,
//                       rating: category.rating.toString(),
//                       locationId: category.placeId ?? "",
//                     ),
//                   ),
//                 );
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 3,
//                     child: category.photoUrls!.isEmpty
//                         ? const ImageWidget(url: "")
//                         : ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: category.photoUrls!.length,
//                             itemBuilder: (BuildContext context, int index1) {
//                               final url = category.photoUrls?[index1];
//                               return ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: ImageWidget(url: url ?? ""),
//                               );
//                             },
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return const SizedBox(width: 10);
//                             },
//                           ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           overflow: TextOverflow.ellipsis,
//                           category.name ?? "",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontVariations: FVariations.w700,
//                             color: const Color(0xFF1A1B28),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       // Text(
//                       //  "(${formatCategory(category.type ?? "")})" ,
//                       //   style: TextStyle(
//                       //     fontSize: 18,
//                       //     fontVariations: FVariations.w700,
//                       //     color: const Color(0xFF1A1B28),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.star_rounded,
//                         size: 18,
//                         color: Color(0xffF4CA12),
//                       ),
//                       category.rating.toString() == "null"
//                           ? const Text(
//                               '0 ',
//                               style: TextStyle(fontSize: 12),
//                             )
//                           : Text(
//                               category.rating.toString(),
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                       Text(
//                         " (${category.userRatingsTotal})",
//                         style: const TextStyle(fontSize: 12),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   SizedBox(
//                       width: 280,
//                       child: LocationRow(
//                         address: category.vicinity ?? "",
//                       )),
//                   const SizedBox(height: 5),
//                   DistanceRow(
//                     walkingTime: category.walkingTime.toString(),
//                     distance: category.distance.toString(),
//                   ),
//                 ],
//               ),
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Container(
//                 height: 6,
//                 decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//             );
//           },
//         )
//       ],
//     );
//   }
// }

// class SinglePlaceSheet extends StatelessWidget {
//   const SinglePlaceSheet(
//       {super.key, required this.category, required this.scrollController});
//
//   final Category category;
//   final ScrollController scrollController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => RestaurantDetailScreen(
//                 distance: category.distance.toString(),
//                 walkingTime:
//                     convertMinutes(int.parse(category.walkingTime.toString())),
//                 address: category.vicinity,
//                 images: category.photoUrls!.isEmpty ? null : category.photoUrls,
//                 name: category.name,
//                 rating: category.rating.toString(),
//                 locationId: category.placeId ?? "",
//               ),
//             ),
//           );
//         },
//         child: ListView(
//           controller: scrollController,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Container(
//                   width: 40,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: const Color(0xffCDCFD0),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             AspectRatio(
//               aspectRatio: 3,
//               child: category.photoUrls!.isEmpty
//                   ? const ImageWidget(url: "")
//                   : ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: category.photoUrls!.length,
//                       itemBuilder: (BuildContext context, int index1) {
//                         final url = category.photoUrls?[index1];
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: ImageWidget(url: url ?? ""),
//                         );
//                       },
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const SizedBox(width: 10);
//                       },
//                     ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               category.name ?? "",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontVariations: FVariations.w700,
//                 color: const Color(0xFF1A1B28),
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Row(
//               children: [
//                 const Icon(
//                   Icons.star_rounded,
//                   size: 18,
//                   color: Color(0xffF4CA12),
//                 ),
//                 category.rating.toString() == "null"
//                     ? const Text(
//                         '0 ',
//                         style: TextStyle(fontSize: 12),
//                       )
//                     : Text(
//                         category.rating.toString(),
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                 Text(
//                   " (${category.userRatingsTotal})",
//                   style: const TextStyle(fontSize: 12),
//                 )
//               ],
//             ),
//             const SizedBox(height: 5),
//             SizedBox(
//                 width: 280,
//                 child: LocationRow(
//                   address: category.vicinity ?? "",
//                 )),
//             const SizedBox(height: 5),
//             DistanceRow(
//               walkingTime: category.walkingTime.toString(),
//               distance: category.distance.toString(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ItineraryPlacesSheet extends StatelessWidget {
//   const ItineraryPlacesSheet(
//       {super.key, required this.itineraries, required this.scrollController});
//
//   final List<ItineraryPlaces> itineraries;
//
//   final ScrollController scrollController;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       controller: scrollController,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               width: 40,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: const Color(0xffCDCFD0),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//         ListView.separated(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           itemCount: itineraries.length,
//           itemBuilder: (BuildContext context, int index) {
//             final category = itineraries[index];
//             return GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => RestaurantDetailScreen(
//                       distance: category.distance.toString(),
//                       walkingTime: convertMinutes(
//                           int.parse(category.walkingTime.toString())),
//                       address: category.vicinity,
//                       name: category.name,
//                       rating: category.rating.toString(),
//                     ),
//                   ),
//                 );
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AspectRatio(
//                     aspectRatio: 3,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: ImageWidget(url: category.photo ?? ""),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     category.name ?? "",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontVariations: FVariations.w700,
//                       color: const Color(0xFF1A1B28),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.star_rounded,
//                         size: 18,
//                         color: Color(0xffF4CA12),
//                       ),
//                       category.rating.toString() == "null"
//                           ? const Text(
//                               '0 ',
//                               style: TextStyle(fontSize: 12),
//                             )
//                           : Text(
//                               category.rating.toString(),
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                       // Text(
//                       //   " (${category})",
//                       //   style: const TextStyle(fontSize: 12),
//                       // )
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   SizedBox(
//                       width: 280,
//                       child: LocationRow(
//                         address: category.vicinity ?? "",
//                       )),
//                   const SizedBox(height: 5),
//                   DistanceRow(
//                     walkingTime: category.walkingTime.toString(),
//                     distance: category.distance.toString(),
//                   ),
//                 ],
//               ),
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Container(
//                 height: 6,
//                 decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//             );
//           },
//         )
//       ],
//     );
//   }
// }

// class ItinerarySinglePlace extends StatelessWidget {
//   const ItinerarySinglePlace(
//       {super.key,
//       required this.itineraryPlaces,
//       required this.scrollController});
//
//   final ItineraryPlaces itineraryPlaces;
//   final ScrollController scrollController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => RestaurantDetailScreen(
//                 distance: itineraryPlaces.distance.toString(),
//                 walkingTime: convertMinutes(
//                     int.parse(itineraryPlaces.walkingTime.toString())),
//                 address: itineraryPlaces.vicinity,
//                 name: itineraryPlaces.name,
//                 rating: itineraryPlaces.rating.toString(),
//               ),
//             ),
//           );
//         },
//         child: ListView(
//           controller: scrollController,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: Container(
//                   width: 40,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: const Color(0xffCDCFD0),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             AspectRatio(
//               aspectRatio: 3,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: ImageWidget(url: itineraryPlaces.photo ?? ""),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               itineraryPlaces.name ?? "",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontVariations: FVariations.w700,
//                 color: const Color(0xFF1A1B28),
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Row(
//               children: [
//                 const Icon(
//                   Icons.star_rounded,
//                   size: 18,
//                   color: Color(0xffF4CA12),
//                 ),
//                 itineraryPlaces.rating.toString() == "null"
//                     ? const Text(
//                         '0 ',
//                         style: TextStyle(fontSize: 12),
//                       )
//                     : Text(
//                         itineraryPlaces.rating.toString(),
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                 // Text(
//                 //   " (${category.userRatingsTotal})",
//                 //   style: const TextStyle(fontSize: 12),
//                 // )
//               ],
//             ),
//             const SizedBox(height: 5),
//             SizedBox(
//                 width: 280,
//                 child: LocationRow(
//                   address: itineraryPlaces.vicinity ?? "",
//                 )),
//             const SizedBox(height: 5),
//             DistanceRow(
//               walkingTime: itineraryPlaces.walkingTime.toString(),
//               distance: itineraryPlaces.distance.toString(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
