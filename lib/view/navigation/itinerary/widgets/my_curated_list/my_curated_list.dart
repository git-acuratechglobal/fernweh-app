import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_model.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/my_curated_list/share_your_itinerary/share_itenary_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/common/extensions.dart';
import '../../../../auth/auth_provider/auth_provider.dart';
import '../../models/itinerary_places.dart';
import '../../notifier/itinerary_notifier.dart';
import '../my_itenary_screen.dart';
import '../shared_list/add_notes/add_notes_sheet.dart';
import '../shared_list/shared_list_details/shared_details_screen.dart';
import 'edit_itenerary/edit_itenerary.dart';

class MyCuratedListTab extends StatelessWidget {
  const MyCuratedListTab(
      {super.key,
      required this.itinary,
      required this.isEditing,
      required this.isSelected,
      this.placeUrls});

  final Itinerary itinary;
  final bool isEditing;
  final bool isSelected;
  final List<String>? placeUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: isSelected ? Colors.red : const Color(0xffE2E2E2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: placeUrls == null
                          ? ImageWidget(url: itinary.imageUrl)
                          : GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: 4,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                              ),
                              itemBuilder: (context, index) {
                                if (index < placeUrls!.length) {
                                  return ImageWidget(url: placeUrls![index]);
                                } else {
                                  return Container(
                                    color: Colors.grey[300],
                                  );
                                }
                              })),
                  Positioned(
                    top: 1,
                    right: 1,
                    child: Image.asset(
                      isSelected
                          ? 'assets/images/selected.png'
                          : 'assets/images/unselected.png',
                    ),
                  )
                ],
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          itinary.name ?? "",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class MyCreatedItinerary extends ConsumerStatefulWidget {
  const MyCreatedItinerary(
      {super.key,
      required this.itinary,
      required this.placeCount,
      required this.editList,
      required this.viewOnly,
      this.placeUrls});

  final Itinerary itinary;
  final int placeCount;
  final List<Can> editList;
  final List<Can> viewOnly;
  final List<String>? placeUrls;

  @override
  ConsumerState<MyCreatedItinerary> createState() => _MyCreatedItineraryState();
}

class _MyCreatedItineraryState extends ConsumerState<MyCreatedItinerary> {
  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userDetailProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 140,
          width: MediaQuery.sizeOf(context).width - 50,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: const Color(0xffE2E2E2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 150,
                width: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.placeUrls == null
                        ? ImageWidget(url: widget.itinary.imageUrl)
                        : GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: 4,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                            itemBuilder: (context, index) {
                              if (index < widget.placeUrls!.length) {
                                return ImageWidget(
                                    url: widget.placeUrls![index]);
                              } else {
                                return Container(
                                  color: Colors.grey[300],
                                );
                              }
                            })),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      widget.itinary.name ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${widget.placeCount} locations",
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
                      child: GestureDetector(
                          onTap: () {
                            // if(widget.editList
                            //     .where((val) => val.id == userId?.id)
                            //     .isNotEmpty){
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                constraints: BoxConstraints.tightFor(
                                  height:
                                  MediaQuery.sizeOf(context).height * 0.85,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return UnShareItenarySheet(
                                    itineraryId: widget.itinary.id!,
                                    viewOnly: widget.viewOnly,
                                    editOnly: widget.editList,
                                  );
                                },
                              );
                            // }

                          },
                          child: AvatarList(images: [
                            ...widget.editList,
                            ...widget.viewOnly
                          ])),
                    )
                    // const Text(
                    //   'Shared with',
                    //   style: TextStyle(
                    //     color: Color(0xFF505050),
                    //     fontSize: 12,
                    //   ),
                    // ),
                    // Flexible(
                    //   flex: 1,
                    //   child: AvatarList(
                    //       images: widget.itinerary.canView!.isEmpty
                    //           ? widget.itinerary.canEdit
                    //           : widget.itinerary.canView),
                    // )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          constraints: BoxConstraints.tightFor(
                            height: MediaQuery.sizeOf(context).height * 0.80,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return EditItenerary(
                              iteneraryPhoto: widget.itinary.imageUrl,
                              iteneraryName: widget.itinary.name ?? "",
                              id: widget.itinary.id,
                              type: int.parse(widget.itinary.type ?? ""),
                            );
                          },
                        );
                      },
                      child: Image.asset('assets/images/edit.png')),
                  const SizedBox(
                    height: 10,
                  ),
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
                            itineraryId: widget.itinary.id ?? 0,
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/images/note.png',
                    ),
                  ),
                  ShareIcon(widget.itinary.id.toString())
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
