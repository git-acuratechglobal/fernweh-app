import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fernweh/utils/common/fav_button.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/utils/widgets/loading_widget.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/navigation/map/notifier/wish_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../utils/common/common.dart';
import '../../../../../../utils/common/config.dart';
import '../../../../../../utils/common/extensions.dart';
import '../../../../explore/explore_screen.dart';
import '../../../../friends_list/add_friend/add_friend_screen.dart';
import '../../../../map/notifier/category_notifier.dart';
import '../../../../map/restaurant_detail/restaurant_detail_screen.dart';
import '../../../models/itinerary_places.dart';
import '../../../models/states/my_itinerary_state.dart';
import '../../../notifier/follow_itinerary_notifier/follow_itinerary.dart';
import '../../../notifier/itinerary_notifier.dart';
import '../../following_list/notifier/followlist_notifier.dart';
import '../../shared_list/shared_list_details/shared_details_screen.dart';

class ItenaryDetailsScreen extends ConsumerStatefulWidget {
  final String title;
  final int itineraryId;
  final int userId;

  const ItenaryDetailsScreen(
      {super.key,
      required this.title,
      required this.itineraryId,
      required this.userId});

  @override
  ConsumerState<ItenaryDetailsScreen> createState() =>
      _ItenaryDetailsScreenState();
}

class _ItenaryDetailsScreenState extends ConsumerState<ItenaryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        ref
            .read(itineraryPlacesNotifierProvider.notifier)
            .getItineraryPlaces(widget.itineraryId);
      });
      ref.listenManual(myItineraryNotifierProvider, (previous, next) {
        switch (next) {
          case MyItineraryUpdatedState() when previous is MyItineraryLoading:
            Common.showSnackBar(context, "Place tag updated");
          case MyItineraryErrorState(error: e):
            Common.showSnackBar(context, e.toString());
          default:
        }
      });

      ref.listenManual(followItineraryProvider, (previous, next) {
        switch (next) {
          case AsyncValue<String?>? data
              when data.value != null && previous is AsyncLoading:
            Common.showSnackBar(context, data.value ?? "");
            ref.invalidate(followingNotifierProvider);
            ref.invalidate(getFollowItinerariesListProvider);
          case AsyncError error:
            Common.showSnackBar(context, error.toString());
          default:
        }
      });
    });
  }

  bool mapView = false;
  DateTime selectedDate = DateTime.now();
  List<DateTime> dates = List.generate(10, (index) {
    final now = DateTime.now();
    return now.add(Duration(days: index));
  });
  int? type;

  @override
  Widget build(BuildContext context) {
    final itineraryState = ref.watch(itineraryLocalListProvider);
    final userId = ref.watch(userDetailProvider)?.id;
    final followState = ref.watch(followItineraryProvider);
    final followingItineraryList = ref.watch(getFollowItinerariesListProvider);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: DefaultTabController(
          length: Config.tabOptions.length,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 18),
                ),
                actions: [
                  if (userId != widget.userId)
                    AsyncDataWidgetB(
                        dataProvider: getFollowItinerariesListProvider,
                        dataBuilder: (data) {
                          bool isFollow =
                              data.contains(widget.itineraryId.toString());
                          return SizedBox(
                            height: 40,
                            width: 100,
                            child: CustomButton(
                              isFollow: isFollow,
                              onTap: () {
                                ref
                                    .read(followItineraryProvider.notifier)
                                    .followItinerary(
                                        userId: widget.userId,
                                        itineraryId: widget.itineraryId);
                              },
                              isLoading: followState.isLoading,
                              child: Text(isFollow ? "Following" : "Follow",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: isFollow
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w900)),
                            ),
                          );
                        },
                        errorBuilder: (error, st) => const SizedBox.shrink()),
                  // followingItineraryList.maybeWhen(data: (data) {
                  //   bool isFollow =
                  //       data.contains(widget.itineraryId.toString());
                  //   return SizedBox(
                  //     height: 40,
                  //     width: 100,
                  //     child: CustomButton(
                  //       isFollow: isFollow,
                  //       onTap: () {
                  //         ref
                  //             .read(followItineraryProvider.notifier)
                  //             .followItinerary(
                  //                 userId: widget.userId,
                  //                 itineraryId: widget.itineraryId);
                  //       },
                  //       isLoading: followState.isLoading,
                  //       child: Text(isFollow ? "Following" : "Follow",
                  //           style: TextStyle(
                  //               fontSize: 12,
                  //               color: isFollow ? Colors.black : Colors.white,
                  //               fontWeight: FontWeight.w900)),
                  //     ),
                  //   );
                  // }, orElse: () {
                  //   return SizedBox(
                  //     height: 40,
                  //     width: 100,
                  //     child: CustomButton(
                  //       isFollow: false,
                  //       onTap: () {
                  //         ref
                  //             .read(followItineraryProvider.notifier)
                  //             .followItinerary(
                  //             userId: widget.userId,
                  //             itineraryId: widget.itineraryId);
                  //       },
                  //       isLoading: followState.isLoading,
                  //       child: const Text( "Follow",
                  //           style: TextStyle(
                  //               fontSize: 12,
                  //               color:  Colors.white,
                  //               fontWeight: FontWeight.w900)),
                  //     ),
                  //   );
                  // }),
                  itineraryState.selectedItems.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(itineraryLocalListProvider.notifier)
                                      .clearSelection();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 15),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Are you sure?'),
                                      content: const Text(
                                          'Do you want to delete place  from Itinerary?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            ref
                                                .read(itineraryLocalListProvider
                                                    .notifier)
                                                .removeSelectedItems();
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('No'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ShareIcon(widget.itineraryId.toString()),
                ],
              ),
              TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                onTap: (val) {
                  switch (val) {
                    case 0:
                      type = 0;
                    case 1:
                      type = 1;
                    case 2:
                      type = 2;
                    case 3:
                      type = 3;
                  }
                  ref
                      .read(itineraryPlacesNotifierProvider.notifier)
                      .getTypeItineraryPlace(widget.itineraryId, type);
                  ref
                      .read(itineraryLocalListProvider.notifier)
                      .removeSelectedItems();
                },
                dividerColor: const Color(0xffE2E2E2),
                labelColor: Theme.of(context).colorScheme.secondary,
                indicatorColor: Theme.of(context).colorScheme.secondary,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: TextStyle(
                  fontFamily: "Plus Jakarta Sans",
                  fontSize: 15,
                  fontVariations: FVariations.w500,
                ),
                labelStyle: TextStyle(
                  fontFamily: "Plus Jakarta Sans",
                  fontSize: 15,
                  fontVariations: FVariations.w700,
                ),
                tabs: Config.tabOptions.map((e) {
                  return Tab(text: e);
                }).toList(),
              ),
              Expanded(
                child: Stack(
                  children: [
                    TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          DetailPage(
                            isMapView: mapView,
                            type: type,
                          ),
                          DetailPage(
                            isMapView: mapView,
                            type: type,
                          ),
                          DetailPage(
                            isMapView: mapView,
                            type: type,
                          ),
                          DetailPage(
                            isMapView: mapView,
                            type: type,
                          ),
                        ]),
                    AnimatedPositioned(
                      bottom: mapView ? 230 : 20,
                      right: mapView ? 10 : 160,
                      duration: const Duration(milliseconds: 200),
                      child: FloatingActionButton(
                        elevation: 0,
                        heroTag: null,
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.black,
                        onPressed: () {
                          setState(() {
                            mapView = !mapView;
                          });
                        },
                        child: Image.asset(mapView
                            ? 'assets/images/task.png'
                            : 'assets/images/map.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends ConsumerStatefulWidget {
  final bool isMapView;
  final int? type;

  const DetailPage({super.key, required this.isMapView, this.type});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  List<Marker> markers = <Marker>[];
  bool _isHide = true;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late GoogleMapController mapController;

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
  Widget build(BuildContext context) {
    final icon = ref.watch(bitmapIconProvider);
    final itineraryState = ref.watch(itineraryLocalListProvider);
    final itineraryNotifier = ref.read(itineraryLocalListProvider.notifier);
    if (widget.isMapView) {
      return LayoutBuilder(builder: (context, snapshot) {
        return Stack(
          children: [
            AsyncDataWidgetB(
              dataProvider: itineraryPlacesNotifierProvider,
              dataBuilder: (itineraryPlace) {
                markers.clear();
                for (var data in itineraryPlace) {
                  markers.add(Marker(
                      icon: icon.value ?? BitmapDescriptor.defaultMarker,
                      consumeTapEvents: true,
                      markerId: MarkerId(data.locationId.toString()),
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
                            .animateCamera(CameraUpdate.newLatLng(latlng))
                            .then((val) {
                          itineraryMarkerInfo(data);
                        });
                      }));
                }

                return GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    zoom: 14.4746,
                    target: LatLng(
                      double.parse(itineraryPlace[0].latitude.toString()),
                      double.parse(itineraryPlace[0].longitude.toString()),
                    ),
                  ),
                  onMapCreated: (controller) async {
                    mapController = controller;
                    _customInfoWindowController.googleMapController =
                        controller;
                    if (itineraryPlace.isNotEmpty) {
                      final bounds = calculateBounds(markers);
                      Future.delayed(const Duration(milliseconds: 500),
                          () async {
                        await mapController.animateCamera(
                          CameraUpdate.newLatLngBounds(
                              bounds, 50), // Adjust padding as needed
                        );
                      });
                    }
                  },
                  onCameraMove: (position) async {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onTap: (latLng) {
                    setState(() {
                      _isHide = !_isHide;
                    });
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  markers: Set.from(markers),
                );
              },
              errorBuilder: (e, st) => Center(
                child: ErrorCustomWidget(
                    error: e,
                    onRetry: () =>
                        ref.invalidate(itineraryPlacesNotifierProvider)),
              ),
              loadingBuilder: const Stack(
                children: [
                  // GoogleMap(
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
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 70,
              width: 220,
              offset: 30,
            ),
            _isHide
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AspectRatio(
                          aspectRatio: 2,
                          child: AsyncDataWidgetB(
                            dataProvider: itineraryPlacesNotifierProvider,
                            dataBuilder: (itineraryPlaces) {
                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount: itineraryPlaces.length,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                itemBuilder: (context, index) {
                                  final data = itineraryPlaces[index];
                                  return DetailItem(
                                    id: data.id,
                                    itineraryId: data.intineraryListId,
                                    userId: data.userId,
                                    locationId: data.locationId,
                                    placeId: data.locationId,
                                    latitude: data.latitude,
                                    longitude: data.longitude,
                                    selection: data.type == 1
                                        ? "WANT TO VISIT"
                                        : data.type == 2
                                            ? "VISITED"
                                            : "VISITED & LIKED",
                                    placeType: data.placeTypes ?? "",
                                    width:
                                        MediaQuery.sizeOf(context).width - 50,
                                    name: data.name,
                                    url: data.photo,
                                    address: data.formattedAddress,
                                    rating: data.rating.toString(),
                                    walkTime: convertMinutes(
                                        int.parse(data.walkingTime.toString())),
                                    distance: data.distance.toString(),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(width: 10.0);
                                },
                              );
                            },
                            errorBuilder: (object, stackTrace) => const Center(
                              child: Text(""),
                            ),
                            loadingBuilder: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Skeletonizer(
                                child: DetailItem(
                                  placeType: "kkklkl",
                                  name: "data.name",
                                  url:
                                      "https://png.pngtree.com/png-vector/20210604/ourmid/pngtree-gray-network-placeholder-png-image_3416659.jpg",
                                  address: "data.vicinity",
                                  rating: "4",
                                  walkTime: "ytytyty",
                                  distance: "uyuyuyu",
                                ),
                              ),
                            ),
                          )),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        );
      });
    }
    return Align(
      alignment: Alignment.topCenter,
      child: AsyncDataWidgetB(
        dataProvider: itineraryPlacesNotifierProvider,
        dataBuilder: (itineraryPlace) {
          return itineraryState.itineraryPlaces.isEmpty
              ? const Center(
                  child: Text("No Places found"),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: itineraryState.itineraryPlaces.length,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 80,
                  ),
                  itemBuilder: (context, index) {
                    final data = itineraryState.itineraryPlaces[index];
                    bool isSelected =
                        itineraryState.selectedItems.contains(data.id);
                    return GestureDetector(
                      onLongPress: () {
                        itineraryNotifier.toggleSelection(data.id ?? 0);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ItinerayItem(
                          addedBy: data.addedByName,
                          showingInWishList: false,
                          // isWishlist: false,
                          isSelected: itineraryState.selectedItems.isNotEmpty,
                          id: data.id,
                          itineraryId: data.intineraryListId,
                          userId: data.userId,
                          locationId: data.locationId,
                          placeId: data.locationId,
                          latitude: data.latitude,
                          longitude: data.longitude,
                          selection: data.type == 1
                              ? "Want to visit"
                              : data.type == 2
                                  ? "Visited"
                                  : "Visited & Liked",
                          placeType: data.placeTypes ?? "",
                          name: data.name,
                          url: data.photo,
                          address: data.formattedAddress,
                          rating: data.rating.toString(),
                          walkTime: convertMinutes(
                              int.parse(data.walkingTime.toString())),
                          distance: data.distance.toString(),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 16.0);
                  },
                );
        },
        errorBuilder: (e, st) => Center(
          child: ErrorCustomWidget(
              error: e,
              onRetry: () => ref.invalidate(itineraryPlacesNotifierProvider)),
        ),
        loadingBuilder: Skeletonizer(
          child: ListView.separated(
            itemCount: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              return const ItinerayItem(
                showingInWishList: false,
                placeType: "kkklkk",
                name: "data.name",
                url:
                    "https://png.pngtree.com/png-vector/20210604/ourmid/pngtree-gray-network-placeholder-png-image_3416659.jpg",
                address: "data.vicinity",
                rating: "4",
                walkTime: "ytytyty",
                distance: "uyuyuyu",
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 16.0);
            },
          ),
        ),
      ),
    );
  }

  void itineraryMarkerInfo(ItineraryPlaces data) {
    _customInfoWindowController.addInfoWindow!(
        ItineraryMarkersInfo(
          data: data,
        ),
        LatLng(double.parse(data.latitude.toString()),
            double.parse(data.longitude.toString())));
  }
}

class ItinerayItem extends ConsumerStatefulWidget {
  final double? width;
  final String? url;
  final String? name;
  final String? address;
  final String? rating;
  final String? walkTime;
  final String? distance;
  final String placeType;
  final String? selection;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final int? itineraryId;
  final int? userId;
  final String? locationId;
  final int? id;
  final int? type;
  final bool isSelected;
  final bool showingInWishList;
  final String? addedBy;

  const ItinerayItem(
      {super.key,
      this.width,
      this.url,
      this.name,
      this.address,
      this.rating,
      this.walkTime,
      this.distance,
      required this.placeType,
      this.selection,
      this.latitude,
      this.placeId,
      this.longitude,
      this.id,
      this.locationId,
      this.userId,
      this.itineraryId,
      this.type,
      this.isSelected = false,
      required this.showingInWishList,
      this.addedBy});

  @override
  ConsumerState<ItinerayItem> createState() => _ItinerayItemState();
}

class _ItinerayItemState extends ConsumerState<ItinerayItem> {
  String? selectedType;

  @override
  void initState() {
    setState(() {
      selectedType = widget.selection;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (widget.isSelected) {
              ref
                  .read(itineraryLocalListProvider.notifier)
                  .toggleSelection(widget.id ?? 0);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(
                    locationId: widget.placeId,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    types: const [],
                    image: widget.url ?? "",
                    name: widget.name,
                    rating: widget.rating,
                    walkingTime: widget.walkTime,
                    distance: widget.distance,
                    address: widget.address,
                  ),
                ),
              );
            }
          },
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: SizedBox(
              height: 190,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        String googleUrl =
                            'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=${widget.placeId}';
                        if (await canLaunchUrl(Uri.parse(googleUrl))) {
                          await launchUrl(Uri.parse(googleUrl));
                        } else {
                          return Common.showToast(
                              context: context,
                              message: "Could not open the place details.");
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                            aspectRatio: 0.85,
                            child: ImageWidget(
                              url: widget.url ?? "",
                            )),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            // width: 140.0,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              widget.name ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                fontVariations: FVariations.w700,
                                color: const Color(0xFF1A1B28),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 04,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: Color(0xffF4CA12),
                              ),
                              Text(
                                widget.rating ?? "0",
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                  color: Color(0xffFFE9E9),
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(6.0),
                                    left: Radius.circular(6.0),
                                  ),
                                ),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  widget.placeType,
                                  style: TextStyle(
                                    color: const Color(0xFFCF5253),
                                    fontSize: 11,
                                    fontVariations: FVariations.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // LocationRow(
                          //   address: widget.address ?? "",
                          // ),
                          const SizedBox(
                            height: 05,
                          ),
                          const Text(
                            "Address:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),

                          Flexible(
                            child: Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                widget.address ?? "",
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500)),
                          ),
                          // DistanceRow(
                          //   walkingTime: widget.walkTime ?? "",
                          //   distance: widget.distance ?? "",
                          // ),

                          widget.showingInWishList
                              ? const SizedBox.shrink()
                              : Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Added by: ${widget.addedBy}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 5,
                          ),
                          widget.showingInWishList
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: ColoredDropdownButton(
                                  selectedType: selectedType ?? "",
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedType = value;
                                    });
                                    ref
                                        .read(myItineraryNotifierProvider
                                            .notifier)
                                        .updateForm("type", widget.type);
                                    ref
                                        .read(myItineraryNotifierProvider
                                            .notifier)
                                        .updateForm(
                                            "itinerary_id", widget.itineraryId);
                                    ref
                                        .read(myItineraryNotifierProvider
                                            .notifier)
                                        .updateMyItinerary(
                                            id: widget.id ?? 0,
                                            form: {
                                          "intineraryListId":
                                              widget.itineraryId,
                                          "type":
                                              selectedType == "Want to visit"
                                                  ? 1
                                                  : selectedType == "Visited"
                                                      ? 2
                                                      : 3,
                                          "locationId": widget.locationId,
                                          "userId": widget.userId
                                        });
                                  },
                                ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ColoredDropdownButton extends StatelessWidget {
  const ColoredDropdownButton({
    super.key,
    required this.selectedType,
    required this.onChanged,
    // required this.index,
  });

  final String? selectedType;
  final ValueChanged<String?> onChanged;

  // final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 45,
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: Config.itinaryOptions.any((e) => e.name == selectedType)
              ? selectedType
              : null,
          hint: const Text(
            'Choose one',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
            color: Colors.grey,
          ),
          isExpanded: true,
          items: Config.itinaryOptions.map((type) {
            return DropdownMenuItem<String>(
              value: type.name,
              child: Text(
                type.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: type.id == 1
                      ? Colors.red
                      : type.id == 2
                          ? Colors.yellow
                          : Colors.green,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ),
    );
  }
}

class DetailItem extends ConsumerStatefulWidget {
  final double? width;
  final String? url;
  final String? name;
  final String? address;
  final String? rating;
  final String? walkTime;
  final String? distance;
  final String placeType;
  final String? selection;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final int? itineraryId;
  final int? userId;
  final String? locationId;
  final int? id;
  final int? type;
  final bool isSelected;

  const DetailItem(
      {super.key,
      this.width,
      this.url,
      this.name,
      this.address,
      this.rating,
      this.walkTime,
      this.distance,
      required this.placeType,
      this.selection,
      this.latitude,
      this.placeId,
      this.longitude,
      this.id,
      this.locationId,
      this.userId,
      this.itineraryId,
      this.type,
      this.isSelected = false});

  @override
  ConsumerState<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends ConsumerState<DetailItem> {
  String? selectedType;

  @override
  void initState() {
    setState(() {
      selectedType = widget.selection;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.width ?? MediaQuery.sizeOf(context).width,
          height: 30,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            color: Color(0xffF7F7F7),
            border: Border(
              top: BorderSide(color: Color(0xffE2E2E2)),
              left: BorderSide(color: Color(0xffE2E2E2)),
              right: BorderSide(color: Color(0xffE2E2E2)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(Config.selectionOptions.length, (index) {
                final option = Config.selectionOptions[index].toUpperCase();
                return InkWell(
                  onTap: () {
                    ref
                        .read(myItineraryNotifierProvider.notifier)
                        .updateForm("type", widget.type);
                    ref
                        .read(myItineraryNotifierProvider.notifier)
                        .updateForm("itinerary_id", widget.itineraryId);
                    ref
                        .read(myItineraryNotifierProvider.notifier)
                        .updateMyItinerary(id: widget.id ?? 0, form: {
                      "intineraryListId": widget.itineraryId,
                      "type": index + 1,
                      "locationId": widget.locationId,
                      "userId": widget.userId
                    });
                  },
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontVariations: FVariations.w600,
                      color: widget.selection == option
                          ? const Color(0xff12B347)
                          : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (widget.isSelected) {
              ref
                  .read(itineraryLocalListProvider.notifier)
                  .toggleSelection(widget.id ?? 0);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(
                    locationId: widget.placeId,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    types: const [],
                    image: widget.url ?? "",
                    name: widget.name,
                    rating: widget.rating,
                    walkingTime: widget.walkTime,
                    distance: widget.distance,
                    address: widget.address,
                  ),
                ),
              );
            }
          },
          child: Container(
            height: 150,
            width: widget.width ?? MediaQuery.sizeOf(context).width,
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              border: Border(
                bottom: BorderSide(color: Color(0xffE2E2E2)),
                left: BorderSide(color: Color(0xffE2E2E2)),
                right: BorderSide(color: Color(0xffE2E2E2)),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ImageWidget(
                            url: widget.url ?? "",
                          )),
                    ),
                    Positioned(
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xffFFE9E9),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          widget.placeType,
                          style: TextStyle(
                            color: const Color(0xFFCF5253),
                            fontSize: 11,
                            fontVariations: FVariations.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 140.0,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              widget.name ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                fontVariations: FVariations.w700,
                                color: const Color(0xFF1A1B28),
                              ),
                            ),
                          ),
                          const FavButton(),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: Color(0xffF4CA12),
                          ),
                          Text(
                            widget.rating ?? "0",
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      LocationRow(
                        address: widget.address ?? "",
                      ),
                      DistanceRow(
                        walkingTime: widget.walkTime ?? "",
                        distance: widget.distance ?? "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ListViewItems extends ConsumerStatefulWidget {
  final double? width;
  final String? url;
  final String? name;
  final String? address;
  final String? rating;
  final String? walkTime;
  final String? distance;
  final String placeType;
  final String? selection;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final int? itineraryId;
  final int? userId;
  final String? locationId;
  final int? id;
  final int? type;
  final bool isSelected;
  final bool isWishlist;
  final String? addedBy;

  const ListViewItems(
      {super.key,
      this.width,
      this.url,
      this.name,
      this.address,
      this.rating,
      this.walkTime,
      this.distance,
      required this.placeType,
      this.selection,
      this.latitude,
      this.placeId,
      this.longitude,
      this.id,
      this.locationId,
      this.userId,
      this.itineraryId,
      this.isSelected = false,
      this.type,
      this.isWishlist = true,
      this.addedBy});

  @override
  ConsumerState<ListViewItems> createState() => _ListViewItemsState();
}

class _ListViewItemsState extends ConsumerState<ListViewItems> {
  String? selectedType;

  @override
  void initState() {
    setState(() {
      selectedType = widget.selection;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.width ?? MediaQuery.sizeOf(context).width,
          height: 35,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            color: Color(0xffF7F7F7),
            border: Border(
              top: BorderSide(color: Color(0xffE2E2E2)),
              left: BorderSide(color: Color(0xffE2E2E2)),
              right: BorderSide(color: Color(0xffE2E2E2)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(Config.selectionOptions.length, (index) {
                final option = Config.selectionOptions[index].toUpperCase();
                return InkWell(
                  onTap: () {
                    // setState(() {
                    //   selectedType= option;
                    // });
                    if (selectedType != null) {
                      ref
                          .read(myItineraryNotifierProvider.notifier)
                          .updateForm("type", widget.type);
                      ref
                          .read(myItineraryNotifierProvider.notifier)
                          .updateForm("itinerary_id", widget.itineraryId);
                      ref
                          .read(myItineraryNotifierProvider.notifier)
                          .updateMyItinerary(id: widget.id ?? 0, form: {
                        "intineraryListId": widget.itineraryId,
                        "type": index + 1,
                        "locationId": widget.locationId,
                        "userId": widget.userId
                      });
                    }
                  },
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontVariations: FVariations.w600,
                      color: selectedType == option
                          ? const Color(0xff12B347)
                          : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (widget.isSelected) {
              // Choose the correct provider based on `isWishlist`
              if (widget.isWishlist) {
                ref
                    .read(wishListProvider.notifier)
                    .toggleSelection(widget.placeId!);
              } else {
                ref
                    .read(itineraryLocalListProvider.notifier)
                    .toggleSelection(widget.id ?? 0);
              }
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(
                    locationId: widget.placeId,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    types: const [],
                    image: widget.url ?? "",
                    name: widget.name,
                    rating: widget.rating,
                    walkingTime: widget.walkTime,
                    distance: widget.distance,
                    address: widget.address,
                  ),
                ),
              );
            }
          },
          child: Container(
            width: widget.width ?? MediaQuery.sizeOf(context).width,
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              border: Border(
                bottom: BorderSide(color: Color(0xffE2E2E2)),
                left: BorderSide(color: Color(0xffE2E2E2)),
                right: BorderSide(color: Color(0xffE2E2E2)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                          aspectRatio: 1.7,
                          child: ImageWidget(
                            url: widget.url ?? "",
                          )),
                    ),
                    Positioned(
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xffFFE9E9),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          widget.placeType,
                          style: TextStyle(
                            color: const Color(0xFFCF5253),
                            fontSize: 11,
                            fontVariations: FVariations.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 12,
                        right: 10,
                        child: FavButton(
                          placeId: widget.placeId,
                          name: widget.name,
                          image: widget.url,
                          type: widget.placeType,
                          distance: widget.distance,
                          rating: widget.rating,
                          address: widget.address,
                          walkingTime: widget.walkTime,
                        )),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      widget.name ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        fontVariations: FVariations.w700,
                        color: const Color(0xFF1A1B28),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xffF4CA12),
                        ),
                        Text(
                          widget.rating ?? "0",
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),

                // InkWell(
                //   onTap: () {
                //     showModalBottomSheet(
                //       context: context,
                //       backgroundColor: Colors.white,
                //       isScrollControlled: true,
                //       constraints: BoxConstraints.tightFor(
                //         height: MediaQuery.sizeOf(context).height * 0.6,
                //       ),
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                //       ),
                //       builder: (context) {
                //         return const AddToItineraySheet();
                //       },
                //     );
                //   },
                //   child: Container(
                //     width: 35,
                //     height: 35,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       shape: BoxShape.circle,
                //       border: Border.all(color: const Color(0xffE2E2E2)),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(6.0),
                //       child: Image.asset(
                //         'assets/images/un_heart.png',
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 8.0),
                LocationRow(
                  address: widget.address ?? "",
                ),
                const SizedBox(height: 8.0),
                DistanceRow(
                  walkingTime: widget.walkTime ?? "",
                  distance: widget.distance ?? "",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ItineraryMarkersInfo extends StatelessWidget {
  const ItineraryMarkersInfo({super.key, required this.data});

  final ItineraryPlaces data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              longitude: data.longitude,
              latitude: data.latitude,
              types: const [],
              distance: data.distance.toString(),
              walkingTime:
                  convertMinutes(int.parse(data.walkingTime.toString())),
              address: data.formattedAddress,
              image: data.photo,
              name: data.name,
              rating: data.rating.toString(),
              locationId: data.locationId ?? "",
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
                  imageUrl: data.photo.toString(),
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
