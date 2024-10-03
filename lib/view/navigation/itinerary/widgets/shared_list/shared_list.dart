import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/itinerary_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/shared_list_details/shared_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../utils/common/extensions.dart';
import '../../models/itinerary_model.dart';
import '../my_curated_list/edit_itenerary/edit_itenerary.dart';
import '../my_itenary_screen.dart';
import 'add_notes/add_notes_sheet.dart';

class SharedListTab extends ConsumerStatefulWidget {
  final bool isMapView;

  const SharedListTab({super.key, required this.isMapView});

  @override
  ConsumerState<SharedListTab> createState() => _SharedListTabState();
}

class _SharedListTabState extends ConsumerState<SharedListTab> {
  @override
  Widget build(BuildContext context, ) {
    return RefreshIndicator(
      color: const Color(0xffCF5253),
      edgeOffset: 10,
      onRefresh: () async {
        ref.invalidate(getUserItineraryProvider);
      },
      child: AsyncDataWidgetB(
          dataProvider: getUserItineraryProvider,
          dataBuilder: (context, sharedItinerary) {
            return sharedItinerary.sharedIteneries!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No shared Itineraries found"),
                        const SizedBox(
                          height: 10,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(60, 40),
                          ),
                          onPressed: () {
                            ref.invalidate(getUserItineraryProvider);
                          },
                          child: const Text(
                            "Refresh",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: sharedItinerary.sharedIteneries!.length,
                    itemBuilder: (context, index) {
                      final itinary = sharedItinerary.sharedIteneries![index];
                      return Column(
                        key: ValueKey(itinary.itinerary?.id??0),
                        children: [
                          SharedItem(
                            itinerary: itinary,
                            placesCount: sharedItinerary
                                    .sharedIteneries?[index].placesCount ??
                                0,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                    // separatorBuilder: (BuildContext context, int index) {
                    //   return const SizedBox(height: 16);
                    // },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = sharedItinerary.sharedIteneries!.removeAt(oldIndex);
                  sharedItinerary.sharedIteneries!.insert(newIndex, item);
                });
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
                        haveAccess: '',
                        shareUrl: ''),
                    canView: [],
                    canEdit: [],
                    placesCount: null),
                placesCount: 0,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 16);
            },
          )),
          errorBuilder: (error, st) => Center(
                child: Text(error.toString()),
              )),
    );
  }
}

class SharedItem extends ConsumerStatefulWidget {
  final double? width;

  const SharedItem({
    super.key,
    required this.itinerary,
    required this.placesCount,
    this.width,
  });

  final Itenery itinerary;
  final int placesCount;

  @override
  ConsumerState<SharedItem> createState() => _SharedItemState();
}

class _SharedItemState extends ConsumerState<SharedItem> {
  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userDetailProvider);
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
                              widget.itinerary.itinerary!.imageUrl)),
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
                  Text(
                    "${widget.placesCount} locations",
                    style: const TextStyle(
                        color: Color(0xFF505050),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
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
                    child: AvatarList(images: [
                      ...?widget.itinerary.canEdit,
                      ...?widget.itinerary.canView
                    ]),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.itinerary.canEdit!.isNotEmpty &&
                    widget.itinerary.canEdit!
                        .where((val) => val.id == userId?.id)
                        .isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          constraints: BoxConstraints.tightFor(
                            height: MediaQuery.sizeOf(context).height * 0.70,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return EditItenerary(
                              iteneraryPhoto:
                                  "http://fernweh.acublock.in/public/${widget.itinerary.itinerary?.image}",
                              iteneraryName:
                                  widget.itinerary.itinerary?.name ?? "",
                              id: widget.itinerary.itinerary?.id,
                              type: int.parse(
                                  widget.itinerary.itinerary?.type ?? ""),
                            );
                          },
                        );
                      },
                      child: Image.asset('assets/images/edit.png')),
                if (widget.itinerary.canEdit!.isNotEmpty &&
                    widget.itinerary.canEdit!
                        .where((val) => val.id == userId?.id)
                        .isNotEmpty)
                  const SizedBox(
                    height: 10,
                  ),
                if (widget.itinerary.canEdit!.isNotEmpty &&
                    widget.itinerary.canEdit!
                        .where((val) => val.id == userId?.id)
                        .isNotEmpty)
                  GestureDetector(
                    onTap: () {
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
                    child: Image.asset(
                      'assets/images/note.png',
                    ),
                  ),
                ShareIcon(widget.itinerary.itinerary?.id.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}
