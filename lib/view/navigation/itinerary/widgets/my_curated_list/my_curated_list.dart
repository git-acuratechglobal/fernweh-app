import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_model.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/common/extensions.dart';
import '../my_itenary_screen.dart';
import '../shared_list/add_notes/add_notes_sheet.dart';
import '../shared_list/shared_list_details/shared_details_screen.dart';
import 'edit_itenerary/edit_itenerary.dart';

class MyCuratedListTab extends StatelessWidget {
  const MyCuratedListTab({
    super.key,
    required this.itinary,
    required this.isEditing,
    required this.isSelected,
  });

  final Itinerary itinary;
  final bool isEditing;
  final bool isSelected;

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
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImageWidget(
                      url:
                          "http://fernweh.acublock.in/public/${itinary.image}")),
            )),
        const SizedBox(
          height: 10,
        ),
        Text(
          itinary.name ?? "",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class MyCreatedItinerary extends StatelessWidget {
  const MyCreatedItinerary(
      {super.key,
      required this.itinary,
      required this.placeCount,
      required this.editList});

  final Itinerary itinary;
  final int placeCount;
  final List<Can> editList;

  @override
  Widget build(BuildContext context) {
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
                height: 130,
                width: 110,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: itinary.image == null
                        ? const ImageWidget(
                            url:
                                "https://cdn-icons-png.flaticon.com/512/2343/2343940.png")
                        : ImageWidget(
                            url:
                                "http://fernweh.acublock.in/public/${itinary.image}")),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itinary.name ?? "",
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
                      "$placeCount locations",
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
                      child: AvatarList(images: editList),
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
                            height: MediaQuery.sizeOf(context).height * 0.70,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return EditItenerary(
                              iteneraryPhoto:
                                  "http://fernweh.acublock.in/public/${itinary.image}",
                              iteneraryName: itinary.name ?? "",
                              id: itinary.id,
                              type: int.parse(itinary.type ?? ""),
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
                            itineraryId: itinary.id ?? 0,
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/images/note.png',
                    ),
                  ),
                  ShareIcon(itinary.id.toString())
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
