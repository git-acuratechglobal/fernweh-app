import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fernweh/utils/common/fav_button.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/utils/widgets/loading_widget.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/itinerary_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../utils/common/config.dart';
import '../../../../../../utils/common/extensions.dart';
import '../../../../explore/explore_screen.dart';
import '../../../../map/notifier/category_notifier.dart';
import '../../../../map/restaurant_detail/restaurant_detail_screen.dart';
import '../../../models/itinerary_places.dart';
import '../../shared_list/shared_list_details/shared_details_screen.dart';

class ItenaryDetailsScreen extends ConsumerStatefulWidget {
  final String title;
  final int itineraryId;

  const ItenaryDetailsScreen(
      {super.key, required this.title, required this.itineraryId});

  @override
  ConsumerState<ItenaryDetailsScreen> createState() =>
      _ItenaryDetailsScreenState();
}

class _ItenaryDetailsScreenState extends ConsumerState<ItenaryDetailsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref
          .read(
          itineraryPlacesNotifierProvider
              .notifier)
          .getItineraryPlaces(
          widget.itineraryId );
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        heroTag: null,
        shape: const StadiumBorder(),
        backgroundColor: Colors.black,
        onPressed: () {
          setState(() {
            mapView = !mapView;
          });
        },
        icon: Image.asset(
            mapView ? 'assets/images/task.png' : 'assets/images/map.png'),
        label: Text(
          mapView ? "ListView" : "MapView",
          style: TextStyle(
            color: Colors.white,
            fontVariations: FVariations.w800,
          ),
        ),
      ),
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
                  ShareIcon(widget.itineraryId.toString()),
                ],
              ),
              TabBar(
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
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child: SizedBox.fromSize(
              //     size: const Size.fromHeight(56),
              //     child: ListView.separated(
              //       padding: const EdgeInsets.symmetric(horizontal: 24),
              //       itemCount: dates.length,
              //       scrollDirection: Axis.horizontal,
              //       itemBuilder: (context, index) {
              //         final date = dates[index];
              //         return InkWell(
              //           onTap: () {
              //             setState(() {
              //               selectedDate = date;
              //             });
              //           },
              //           child: Container(
              //             width: 55,
              //             height: 50,
              //             decoration: ShapeDecoration(
              //               color: Colors.white,
              //               shape: RoundedRectangleBorder(
              //                 side: BorderSide(
              //                   width: 1,
              //                   color: selectedDate.day == date.day
              //                       ? const Color(0xff1A72FF)
              //                       : const Color(0xFFE2E2E2),
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text(
              //                   "${date.day}/${date.month}",
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                     fontVariations: FVariations.w700,
              //                   ),
              //                 ),
              //                 Text(
              //                   DateFormat("EEE").format(date),
              //                   textAlign: TextAlign.center,
              //                   style: const TextStyle(
              //                     color: Color(0xFF9A9A9A),
              //                     fontSize: 12,
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //       separatorBuilder: (BuildContext context, int index) {
              //         return const SizedBox(width: 8.0);
              //       },
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      DetailPage(isMapView: mapView),
                      DetailPage(isMapView: mapView),
                      DetailPage(isMapView: mapView),
                      DetailPage(isMapView: mapView),
                    ]),
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

  const DetailPage({
    super.key,
    required this.isMapView,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  List<Marker> markers = <Marker>[];
  bool _isHide = true;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final icon =
        ref.watch(bitmapIconProvider(MediaQuery.devicePixelRatioOf(context)));
    if (widget.isMapView) {
      return LayoutBuilder(builder: (context, snapshot) {
        return Stack(
          children: [
            AsyncDataWidgetB(
              dataProvider: itineraryPlacesNotifierProvider,
              dataBuilder: (BuildContext context, itineraryPlace) {
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
                    final latlng = LatLng(
                      double.parse(itineraryPlace[0].latitude.toString()),
                      double.parse(itineraryPlace[0].longitude.toString()),
                    );
                    await mapController
                        .animateCamera(CameraUpdate.newLatLng(latlng));
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
                child: Text(e.toString()),
              ),
              loadingBuilder: const Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      zoom: 14.4746,
                      target: LatLng(30.7333, 76.7794),
                    ),
                  ),
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
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AspectRatio(
                          aspectRatio: 2,
                          child: AsyncDataWidgetB(
                            dataProvider: itineraryPlacesNotifierProvider,
                            dataBuilder:
                                (BuildContext context, itineraryPlaces) {
                              return ListView.separated(
                                itemCount: itineraryPlaces.length,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                itemBuilder: (context, index) {
                                  final data = itineraryPlaces[index];
                                  return DetailItem(
                                    selection: data.type == 1
                                        ? "VISITED"
                                        : data.type == 2
                                            ? "WILL VISIT"
                                            : "WANT TO VISIT",
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
                                  return const SizedBox(width: 24.0);
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
                                  url: "data.photo",
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
    return AsyncDataWidgetB(
      dataProvider: itineraryPlacesNotifierProvider,
      dataBuilder: (context, itineraryPlace) {
        return itineraryPlace.isEmpty
            ? Skeletonizer(
                child: ListView.separated(
                  itemCount: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index) {
                    return const DetailItem(
                      placeType: "kjhjhjhkjh",
                      name: "data.name",
                      url: "data.photo",
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
              )
            : ListView.separated(
                itemCount: itineraryPlace.length,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) {
                  final data = itineraryPlace[index];
                  return DetailItem(
                    selection: data.type == 1
                        ? "VISITED"
                        : data.type == 2
                            ? "WILL VISIT"
                            : "WANT TO VISIT",
                    placeType: data.placeTypes ?? "",
                    name: data.name,
                    url: data.photo,
                    address: data.formattedAddress,
                    rating: data.rating.toString(),
                    walkTime:
                        convertMinutes(int.parse(data.walkingTime.toString())),
                    distance: data.distance.toString(),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 16.0);
                },
              );
      },
      errorBuilder: (e, st) => Center(
        child: Text(e.toString()),
      ),
      loadingBuilder: Skeletonizer(
        child: ListView.separated(
          itemCount: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            return const DetailItem(
              placeType: "kkklkk",
              name: "data.name",
              url: "data.photo",
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

class DetailItem extends StatefulWidget {
  final double? width;
  final String? url;
  final String? name;
  final String? address;
  final String? rating;
  final String? walkTime;
  final String? distance;
  final String placeType;
  final String? selection;

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
      this.selection});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              image: widget.url ?? "",
              name: widget.name,
              rating: widget.rating,
              walkingTime: widget.walkTime,
              distance: widget.distance,
              address: widget.address,
            ),
          ),
        );
      },
      child: Column(
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
                children:
                    List.generate(Config.selectionOptions.length, (index) {
                  final option = Config.selectionOptions[index].toUpperCase();
                  return Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontVariations: FVariations.w600,
                      color: widget.selection == option
                          ? const Color(0xff12B347)
                          : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
          ),
          Container(
            width: widget.width ?? MediaQuery.sizeOf(context).width,
            height: 150,
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
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
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
                                )
                              ],
                            ),
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
                          const FavButton(),
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
        ],
      ),
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
