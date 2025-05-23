import 'package:easy_debounce/easy_debounce.dart';
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
import '../../auth/auth_provider/auth_provider.dart';
import '../../location_permission/location_screen.dart';
import '../../location_permission/location_service.dart';
import '../collections/models/itinerary_model.dart';
import '../collections/models/itinerary_places.dart';
import '../collections/notifier/itinerary_notifier.dart';
import '../explore/current_location/current_location.dart';
import '../explore/explore_screen.dart';
import '../explore/recommended/recommended.dart';
import '../explore/search_filter/search_and_filter_widget.dart';
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
    ref
        .read(currentPositionProvider.notifier)
        .updatePositionForSearchArea(position);
    setState(() {
      floatingButtonsHide = false;
    });
  }

  LatLngBounds calculateBounds(List<Marker> markers) {
    assert(markers.isNotEmpty);
    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (var marker in markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      final locationPermissionStatus = await Geolocator.checkPermission();
      final isGpsOn = await Geolocator.isLocationServiceEnabled();
      if (locationPermissionStatus == LocationPermission.denied ||
          locationPermissionStatus == LocationPermission.deniedForever ||
          !isGpsOn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LocationPermissionScreen(),
          ),
        );
        return;
      }
      // ref.listenManual<Position?>(positionProvider, (previous, current) async{
      //   if (current != null) {
      //    await mapController.animateCamera(
      //       CameraUpdate.newLatLng(
      //         LatLng(current.latitude, current.longitude),
      //       ),
      //     );
      //   }
      // });
    });
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
    final categoryData = ref.watch(itineraryNotifierProvider);
    final itineraryData = ref.watch(itineraryPlacesNotifierProvider);
    final right = (categoryData.maybeWhen(
              data: (data) => data.isEmpty,
              orElse: () => true,
            ) &&
            itineraryData.maybeWhen(
              data: (data) => data.isEmpty,
              orElse: () => true,
            ))
        ? 0
        : (!_categoryMapView || !_itineraryMapView)
            ? 170
            : 0;

    final bottom = (categoryData.maybeWhen(
              data: (data) => data.isEmpty,
              orElse: () => true,
            ) &&
            itineraryData.maybeWhen(
              data: (data) => data.isEmpty,
              orElse: () => true,
            ))
        ? 10
        : (!_categoryMapView || !_itineraryMapView)
            ? 10
            : 180;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                          dataBuilder: (data) {
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
                          errorBuilder: (error, stack) =>
                              const Text("Unable to load location"),
                        )
                      ],
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
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
                                dataBuilder: (category) {
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
                                        final bounds = calculateBounds(markers);
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () async {
                                          await mapController.animateCamera(
                                            CameraUpdate.newLatLngBounds(bounds,
                                                100), // Adjust padding as needed
                                          );
                                        });
                                      } else {
                                        await mapController.animateCamera(
                                            CameraUpdate.newLatLng(
                                          LatLng(currentPosition?.latitude??0.0,
                                              currentPosition?.longitude??0.0),
                                        ));
                                      }
                                    },
                                    onTap: (controller) {
                                      setState(() {
                                        itemsHide = !itemsHide;
                                      });
                                    },
                                    initialCameraPosition: latLag == null
                                        ? CameraPosition(
                                            zoom: 14,
                                            target: LatLng(
                                                currentPosition?.latitude??0.0,
                                                currentPosition?.longitude??0.0))
                                        : CameraPosition(
                                            zoom: 13,
                                            target: LatLng(latLag.latitude,
                                                latLag.longitude),
                                          ),
                                    markers: Set.from(markers),
                                    onCameraMoveStarted: () {
                                      setState(() {
                                        showSearchMessage = false;
                                      });
                                      EasyDebounce.debounce(
                                        'search-message',
                                        const Duration(seconds: 3),
                                        () {
                                          setState(() {
                                            showSearchMessage = true;
                                          });
                                        },
                                      );
                                    },
                                    onCameraMove: (position) {
                                      setState(() {
                                        _latLng = position.target;
                                      });
                                    },
                                  );
                                },
                                loadingBuilder: const Scaffold(
                                  backgroundColor: Colors.black54,
                                  body: Center(child: LoadingWidget()),
                                ),
                                errorBuilder: (error, stack) =>
                                    const SizedBox())),
                      ),

                    ///   *** here we show map of itinerary list when we press on itinerary list then marker show of itinerary

                    if (mapViewState.itineraryView)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Visibility.maintain(
                          visible: _itineraryMapView,
                          child: AsyncDataWidgetB(
                              dataProvider: itineraryPlacesNotifierProvider,
                              dataBuilder: (itineraryPlace) {
                                markers.clear();
                                if (itineraryPlace.isNotEmpty) {
                                  for (var data in itineraryPlace) {
                                    markers.add(Marker(
                                        icon: icon.value ??
                                            BitmapDescriptor.defaultMarker,
                                        consumeTapEvents: true,
                                        markerId: MarkerId(
                                            data.locationId.toString()),
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
                                            // itineraryMarkerInfo(data);
                                          });
                                          setState(() {
                                            _scrollToSelectedItineraryPlace(
                                                itineraryPlace,
                                                data.id.toString());
                                            selectedPlaceId =
                                                data.id.toString();
                                          });
                                        }));
                                  }
                                }

                                return GoogleMap(
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    zoom: 10.0,
                                    target: latLag == null
                                        ? LatLng(currentPosition?.latitude??0.0,
                                            currentPosition?.longitude??0.0)
                                        : LatLng(
                                            latLag.latitude, latLag.longitude),
                                  ),
                                  onMapCreated: (controller) async {
                                    mapController = controller;
                                    final bounds = calculateBounds(markers);
                                    Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () async {
                                      await mapController.animateCamera(
                                        CameraUpdate.newLatLngBounds(bounds,
                                            100), // Adjust padding as needed
                                      );
                                    });
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
                              loadingBuilder: const Scaffold(
                                backgroundColor: Colors.black45,
                                body: Center(
                                  child: LoadingWidget(),
                                ),
                              )),
                        ),
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

                          ///*** this is category list

                          SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 56,
                              child: AsyncDataWidgetB(
                                  dataProvider: categoriesProvider,
                                  dataBuilder: (categoryData) {
                                    return ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final category =
                                            Config.dashboardCategories[index];
                                        return RawChip(
                                          backgroundColor:
                                              mapViewState.selectedCategory ==
                                                      category.title
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
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
                                                'selected_distance': filters[
                                                    'selected_distance'],
                                                'selected_radius':
                                                    filters['selected_radius'],
                                                'input': filters['input'],
                                                'search_term':
                                                    filters['search_term'],
                                              };
                                              ref
                                                  .read(
                                                      filtersProvider.notifier)
                                                  .updateFilter(filterData);
                                              ref.invalidate(
                                                  itineraryNotifierProvider);
                                              return;
                                            } else {
                                              setState(() {
                                                floatingButtonsHide = false;
                                              });
                                              mapState.update(
                                                  categoryView: true,
                                                  itineraryView: false,
                                                  selectedCategory:
                                                      category.title,
                                                  selectedItinerary: -1);
                                              filterData = {
                                                'type': category.type,
                                                'rating': filters['rating'],
                                                'radius': filters['radius'],
                                                'sort_by': filters['sort_by'],
                                                'selected_category':
                                                    category.title,
                                                'selected_rating':
                                                    filters['selected_rating'],
                                                'selected_distance': filters[
                                                    'selected_distance'],
                                                'selected_radius':
                                                    filters['selected_radius'],
                                                'input': filters['input'],
                                                'search_term':
                                                    filters['search_term'],
                                              };
                                              ref
                                                  .read(
                                                      filtersProvider.notifier)
                                                  .updateFilter(filterData);
                                              ref
                                                  .read(
                                                      itineraryNotifierProvider
                                                          .notifier)
                                                  .filteredItinerary();
                                              ref.invalidate(
                                                  itineraryPlacesNotifierProvider);
                                            }
                                          },
                                          avatar: Icon(
                                            category.icon,
                                            color:
                                                mapViewState.selectedCategory ==
                                                        category.title
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: const BorderSide(
                                                color: Color(0xffE2E2E2)),
                                          ),
                                          label: Text(
                                            category.title,
                                            style: TextStyle(
                                                color: mapViewState
                                                            .selectedCategory ==
                                                        category.title
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(width: 6.0);
                                      },
                                      itemCount:
                                          Config.dashboardCategories.length,
                                    );
                                  },
                                  errorBuilder: (error, st) =>
                                      const SizedBox.shrink())),

                          ///*** here is the user itinerary list widget

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 36,
                            child: AsyncDataWidgetB(
                              dataProvider: getUserItineraryProvider,
                              dataBuilder: (itinerary) {
                                final List<Itenery> filteredList = itinerary
                                    .userItinerary.userIteneries!
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
                                                // filterData = {
                                                //   'type': null,
                                                //   'rating': filters['rating'],
                                                //   'radius': filters['radius'],
                                                //   'sort_by': filters['sort_by'],
                                                //   'selected_category': "All",
                                                //   'selected_rating': filters[
                                                //       'selected_rating'],
                                                //   'selected_distance': filters[
                                                //       'selected_distance'],
                                                //   'selected_radius': filters[
                                                //       'selected_radius'],
                                                //   'input': filters['input'],
                                                //   'search_term':
                                                //       filters['search_term'],
                                                // };
                                                // ref
                                                //     .read(filtersProvider
                                                //         .notifier)
                                                //     .updateFilter(filterData);
                                                ref.invalidate(
                                                    itineraryPlacesNotifierProvider);
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
                                                ref.invalidate(
                                                    itineraryNotifierProvider);
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
                                dataBuilder: (category) {
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
                                    child: Text("No Collection Found")))),
                      ),

                    ///*** if titinearay is map view then this widget show

                    if (_itineraryMapView && mapViewState.itineraryView)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AspectRatio(
                              aspectRatio: 2.7,
                              child: AsyncDataWidgetB(
                                  dataProvider: itineraryPlacesNotifierProvider,
                                  dataBuilder: (category) {
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
                                      child: Text("No Collection Found")))),
                        ),
                      ),

                    ///*** if category view is list view
                    if (!_categoryMapView && mapViewState.categoryView)
                      Positioned.fill(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 180),
                            child: AsyncDataWidgetB(
                                dataProvider: itineraryNotifierProvider,
                                dataBuilder: (category) {
                                  return ListView.separated(
                                    itemCount: category.length,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12.0),
                                    itemBuilder: (context, index) {
                                      final data = category[index];
                                      print(data.type);
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
                                                data.type ?? ["All"],
                                                mapViewState.selectedCategory),
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
                                    child: Text("No Collection Found")))),
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
                                  dataBuilder: (category) {
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
                                                          data.type ?? ["All"],
                                                          mapViewState
                                                              .selectedCategory),
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
                                      child: Text("No Collection Found")))),
                        ),
                      ),
                    AnimatedPositioned(
                      right: right.toDouble(),
                      bottom: bottom.toDouble(),
                      duration: const Duration(milliseconds: 200),
                      child: mapViewState.categoryView
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 05),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    _categoryMapView
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: IconButton(
                                                  onPressed: () async {
                                                    ref.invalidate(
                                                        currentPositionProvider);
                                                    ref.invalidate(
                                                        mapViewStateProvider);
                                                    ref.invalidate(
                                                        itineraryNotifierProvider);
                                                    setState(() {
                                                      floatingButtonsHide =
                                                          true;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.gps_fixed_outlined),
                                                ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 05),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    _itineraryMapView
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Center(
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


}
