import 'dart:io';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/itinerary_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/shared_list_details/shared_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../utils/common/config.dart';
import '../../../../../utils/common/extensions.dart';
import '../../models/itinerary_model.dart';
import '../my_itenary_screen.dart';

class SharedListTab extends ConsumerWidget {
  final bool isMapView;

  const SharedListTab({super.key, required this.isMapView});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isMapView) {
      return LayoutBuilder(builder: (context, snapshot) {
        return Stack(
          fit: StackFit.expand,
          children: [
            const GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 14.4746,
                target: LatLng(30.7333, 76.7794),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AspectRatio(
                    aspectRatio: 2.8,
                    child: AsyncDataWidgetB(
                        dataProvider: getUserItineraryProvider,
                        dataBuilder: (context, sharedItinerary) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount:
                                sharedItinerary.sharedIteneries!.length,
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            itemBuilder: (context, index) {
                              final itinerary =
                                  sharedItinerary.sharedIteneries![index];
                              return SharedItem(
                                itinerary: itinerary,
                                width: MediaQuery.sizeOf(context).width - 50,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(width: 24.0);
                            },
                          );
                        },
                        loadingBuilder: Skeletonizer(
                            child: ListView.separated(
                          itemCount: 6,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemBuilder: (context, index) {
                            return SharedItem(
                              itinerary: Itenery(
                                  itinerary: Itinerary(
                                      id: null,
                                      userId: null,
                                      name: 'dummy name',
                                      type: '',
                                      image: 'assets/images/attractions.png',
                                      canView: '',
                                      canEdit: '',
                                      isDeleted: null,
                                      createdAt: null,
                                      updatedAt: null,
                                      haveAccess: ''),
                                  canView: [],
                                  canEdit: []),
                              width: MediaQuery.sizeOf(context).width - 50,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 24.0);
                          },
                        )),
                        errorBuilder: (error, st) => Center(
                              child: Text(error.toString()),
                            ))),
              ),
            )
          ],
        );
      });
    }
    return AsyncDataWidgetB(
        dataProvider: getUserItineraryProvider,
        dataBuilder: (context, sharedItinerary) {
          return sharedItinerary.sharedIteneries!.isEmpty
              ? const Text("No shared Itineraries")
              : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: sharedItinerary.sharedIteneries!.length,
                itemBuilder: (context, index) {
                  final itinary = sharedItinerary.sharedIteneries![index];
                  return SharedItem(itinerary: itinary);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 16);
                },
              );
        },
        loadingBuilder: Skeletonizer(
            child: ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: 6,
          itemBuilder: (context, index) {
            return SharedItem(
                itinerary: Itenery(
                    itinerary: Itinerary(
                        id: null,
                        userId: null,
                        name: 'dummy name',
                        type: '',
                        image: 'assets/images/attractions.png',
                        canView: '',
                        canEdit: '',
                        isDeleted: null,
                        createdAt: null,
                        updatedAt: null,
                        haveAccess: ''),
                    canView: [],
                    canEdit: []));
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
        )),
        errorBuilder: (error, st) => Center(
              child: Text(error.toString()),
            ));
  }
}

class SharedItem extends ConsumerStatefulWidget {
  final double? width;

  const SharedItem({
    super.key,
    required this.itinerary,
    this.width,
  });

  final Itenery itinerary;

  @override
  ConsumerState<SharedItem> createState() => _SharedItemState();
}

class _SharedItemState extends ConsumerState<SharedItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // ref
        //     .read(
        //     itineraryPlacesNotifierProvider
        //         .notifier)
        //     .getItineraryPlaces(
        //     widget.itinerary.itinerary!.id??0);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SharedDetailsScreen(
              itinerary: widget.itinerary,
            ),
          ),
        );
      },
      child: Container(
        width: widget.width ?? MediaQuery.sizeOf(context).width,
        height: 140,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffE2E2E2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageWidget(
                      url:
                          "http://fernweh.acublock.in/public/${widget.itinerary.itinerary!.image}")),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      widget.itinerary.itinerary!.name ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                  ),
                  const Text(
                    'Shared with',
                    style: TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 12,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: AvatarList(
                        images: widget.itinerary.canView!.isEmpty
                            ? widget.itinerary.canEdit
                            : widget.itinerary.canView),
                  )
                ],
              ),
            ),
            const ShareIcon("")
          ],
        ),
      ),
    );
  }
}
