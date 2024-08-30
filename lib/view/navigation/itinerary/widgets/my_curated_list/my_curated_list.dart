import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/itinerary/models/itinerary_model.dart';
import 'package:flutter/material.dart';

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
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: isSelected ? Colors.red : const Color(0xffE2E2E2),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageWidget(
                        url:
                            "http://fernweh.acublock.in/public/${itinary.image}")),
              ),
            ),
            if (isEditing)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                            constraints: BoxConstraints.tightFor(
                              height: MediaQuery.sizeOf(context).height * 0.65,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return EditItenerary(
                                iteneraryPhoto:
                                    "http://fernweh.acublock.in/public/${itinary.image}",
                                iteneraryName: itinary.name ?? "",
                                id: itinary.id,
                              );
                            },
                          );
                        },
                        child: Image.asset('assets/images/edit.png'))),
              ),
          ],
        ),
        Text(
          itinary.name ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
