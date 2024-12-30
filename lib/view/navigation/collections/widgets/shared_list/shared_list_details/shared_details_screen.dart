import 'package:custom_info_window/custom_info_window.dart';
import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../utils/common/action_button.dart';
import '../../../../../../utils/widgets/loading_widget.dart';
import '../../../../friends_list/friends_screen.dart';
import '../../../../map/notifier/category_notifier.dart';
import '../../../models/itinerary_model.dart';
import '../../../models/itinerary_places.dart';
import '../../../notifier/itinerary_notifier.dart';
import '../../my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import '../../my_curated_list/share_your_itinerary/share_itenary_sheet.dart';
import '../../my_itenary_screen.dart';
import '../add_notes/add_notes_sheet.dart';

class SharedDetailsScreen extends ConsumerStatefulWidget {
  final Itenery itinerary;

  const SharedDetailsScreen({
    super.key,
    required this.itinerary,
  });

  @override
  ConsumerState<SharedDetailsScreen> createState() =>
      _SharedDetailsScreenState();
}

class _SharedDetailsScreenState extends ConsumerState<SharedDetailsScreen> {
  bool _isMapView = true;
  List<Marker> markers = <Marker>[];
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late GoogleMapController mapController;
  bool _isHide = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(itineraryPlacesNotifierProvider.notifier)
          .getItineraryPlaces(widget.itinerary.itinerary!.id ?? 0);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final icon = ref.watch(bitmapIconProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ActionButton(
        value: _isMapView,
        onPressed: () {
          setState(() {
            _isMapView = !_isMapView;
          });
        },
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
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
                widget.itinerary.itinerary!.name ?? "",
                style: const TextStyle(fontSize: 18),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      constraints: BoxConstraints.tightFor(
                        height: MediaQuery.sizeOf(context).height * 0.85,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return AddNotesSheet(
                          itineraryId: widget.itinerary.itinerary!.id ?? 0,
                        );
                      },
                    );
                  },
                  icon: Image.asset(
                    'assets/images/note.png',
                  ),
                ),
                const ShareIcon(""),
              ],
            ),
            const SizedBox(height: 16),
            _isMapView
                ? Expanded(
                    child: Stack(
                      children: [
                        Visibility.maintain(
                            visible: _isMapView,
                            child: AsyncDataWidgetB(
                              dataProvider: itineraryPlacesNotifierProvider,
                              dataBuilder:
                                  ( itineraryPlace) {
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
                                        setState(() {
                                          _isHide = true;
                                        });
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
                                      }));
                                }
                                return itineraryPlace.isEmpty
                                    ? const Stack(
                                        children: [
                                          GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                              zoom: 14.4746,
                                              target: LatLng(30.7333, 76.7794),
                                            ),
                                          ),
                                          Scaffold(
                                            backgroundColor: Colors.black54,
                                            body: Center(
                                              child: LoadingWidget(),
                                            ),
                                          )
                                        ],
                                      )
                                    : GoogleMap(
                                        myLocationButtonEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          zoom: 14.4746,
                                          target: LatLng(
                                            double.parse(itineraryPlace[0]
                                                .latitude
                                                .toString()),
                                            double.parse(itineraryPlace[0]
                                                .longitude
                                                .toString()),
                                          ),
                                        ),
                                        onMapCreated: (controller) async {
                                          mapController = controller;
                                          _customInfoWindowController
                                              .googleMapController = controller;
                                          if (itineraryPlace.isNotEmpty) {
                                            final bounds =
                                                calculateBounds(markers);
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500),
                                                () async {
                                              await mapController.animateCamera(
                                                CameraUpdate.newLatLngBounds(
                                                    bounds,
                                                    50), // Adjust padding as needed
                                              );
                                            });
                                          }
                                        },
                                        onCameraMove: (position) async {
                                          _customInfoWindowController
                                              .onCameraMove!();
                                        },
                                        onTap: (latLng) {
                                          setState(() {
                                            _isHide = !_isHide;
                                          });
                                          _customInfoWindowController
                                              .hideInfoWindow!();
                                        },
                                        markers: Set.from(markers),
                                      );
                              },
                              errorBuilder: (e, st) => const SizedBox(),
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
                            )),
                        CustomInfoWindow(
                          controller: _customInfoWindowController,
                          height: 70,
                          width: 220,
                          offset: 30,
                        ),
                        _isHide
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 100),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AspectRatio(
                                      aspectRatio: 2.0,
                                      child: AsyncDataWidgetB(
                                          dataProvider:
                                              itineraryPlacesNotifierProvider,
                                          dataBuilder:
                                              ( itineraryPlaces) {
                                            return ListView.separated(
                                              itemCount: itineraryPlaces.length,
                                              scrollDirection: Axis.horizontal,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              itemBuilder: (context, index) {
                                                final data =
                                                    itineraryPlaces[index];
                                                return SizedBox(
                                                    width: 350,
                                                    child: DetailItem(
                                                      selection: data.type == 1
                                                          ? "WANT TO VISIT"
                                                          : data.type == 2
                                                              ? "VISITED"
                                                              : "WILL VISIT AGAIN",
                                                      placeType:
                                                          data.placeTypes ?? "",
                                                      name: data.name,
                                                      url: data.photo,
                                                      rating: data.rating
                                                          .toString(),
                                                      walkTime: data.walkingTime
                                                          .toString(),
                                                      distance: data.distance
                                                          .toString(),
                                                      address:
                                                          data.formattedAddress,
                                                    ));
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return const SizedBox(
                                                    width: 15.0);
                                              },
                                            );
                                          },
                                          loadingBuilder: Skeletonizer(
                                              child: ListView.separated(
                                            itemCount: 6,
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            itemBuilder: (context, index) {
                                              return const SizedBox(
                                                  width: 350,
                                                  child: DetailItem(
                                                    placeType: "lkjjjh",
                                                    name: "data.name",
                                                    url: "data.photo",
                                                    address: "data.vicinity",
                                                    rating: "4",
                                                    walkTime: "ytytyty",
                                                    distance: "uyuyuyu",
                                                  ));
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return const SizedBox(
                                                  width: 15.0);
                                            },
                                          )),
                                          errorBuilder: (error, st) => Center(
                                                child: Text(error.toString()),
                                              ))),
                                ),
                              )
                      ],
                    ),
                  )
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                                aspectRatio: 2,
                                child: ImageWidget(
                                    url:
                                        "http://fernweh.acublock.in/public/${widget.itinerary.itinerary!.image}")),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Shared with',
                            style: TextStyle(
                              color: Color(0xFF505050),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FriendsScreen(isBack: true),
                                ),
                              );
                            },
                            child: widget.itinerary.canView!.isEmpty &&
                                    widget.itinerary.canEdit!.isEmpty
                                ? const SizedBox.shrink()
                                : Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 40,
                                        child: AvatarList(
                                            images: widget
                                                    .itinerary.canView!.isEmpty
                                                ? widget.itinerary.canEdit
                                                : widget.itinerary.canView),
                                      ),
                                      const SizedBox(width: 16),
                                      widget.itinerary.canView!.length > 3 ||
                                              widget.itinerary.canEdit!.length >
                                                  3
                                          ? Text(
                                              widget.itinerary.canView!.isEmpty
                                                  ? "+${widget.itinerary.canEdit!.length} more"
                                                  : "+${widget.itinerary.canView!.length} more",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontVariations:
                                                    FVariations.w700,
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                          ),
                        ),
                        Expanded(
                            child: AsyncDataWidgetB(
                                dataProvider: itineraryPlacesNotifierProvider,
                                dataBuilder: ( itineraryPlaces) {
                                  return ListView.separated(
                                    padding: const EdgeInsets.all(24),
                                    itemCount: itineraryPlaces.length,
                                    itemBuilder: (context, index) {
                                      final data = itineraryPlaces[index];
                                      return DetailItem(
                                        selection: data.type == 1
                                            ? "VISITED"
                                            : data.type == 2
                                                ? "WILL VISIT"
                                                : "WANT TO VISIT",
                                        placeType: data.placeTypes ?? "",
                                        name: data.name,
                                        url: data.photo,
                                        rating: data.rating.toString(),
                                        walkTime: data.walkingTime.toString(),
                                        distance: data.distance.toString(),
                                        address: data.formattedAddress,
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 16);
                                    },
                                  );
                                },
                                loadingBuilder: Skeletonizer(
                                    child: ListView.separated(
                                  padding: const EdgeInsets.all(24),
                                  itemCount: 8,
                                  itemBuilder: (context, index) {
                                    return const DetailItem(
                                      placeType: "klklkl",
                                      name: "data.name",
                                      url: "data.photo",
                                      address: "data.vicinity",
                                      rating: "4",
                                      walkTime: "ytytyty",
                                      distance: "uyuyuyu",
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 16);
                                  },
                                )),
                                errorBuilder: (error, st) => Center(
                                      child: Text(error.toString()),
                                    ))),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void navigateToScreen(ItineraryPlaces data) {
    _customInfoWindowController.addInfoWindow!(
        ItineraryMarkersInfo(
          data: data,
        ),
        LatLng(double.parse(data.latitude.toString()),
            double.parse(data.longitude.toString())));
  }
}

class ShareIcon extends StatelessWidget {
  const ShareIcon(
    this.itineraryId, {
    super.key,
  });

  final String? itineraryId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          constraints: BoxConstraints.tightFor(
            height: MediaQuery.sizeOf(context).height * 0.85,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return ShareItenarySheet(itineraryId);
          },
        );
      },
      icon: Image.asset('assets/images/export.png'),
    );
  }
}
