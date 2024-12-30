import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../utils/common/extensions.dart';
import '../../../../utils/common/fav_button.dart';
import '../../../../utils/widgets/loading_widget.dart';
import '../explore_screen.dart';

class RecommendedItem extends StatelessWidget {
  const RecommendedItem(
      {super.key,
      this.type,
      this.image,
      this.name,
      this.rating,
      this.walkingTime,
      this.distance,
      this.placeId,
      required this.address});

  final String? type;
  final String? image;
  final String? name;
  final String? rating;
  final String? walkingTime;
  final String? distance;
  final String address;
  final String? placeId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 160,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xffE2E2E2)),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                    aspectRatio: 0.9,
                    child: CachedNetworkImage(
                        imageUrl: image.toString(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        progressIndicatorBuilder: (context, url, progress) =>
                            const Center(child: LoadingWidget()),
                        fit: BoxFit.cover)),
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
                              SizedBox(
                                width: 170,
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  name ?? "Juliana’s Pizza",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontVariations: FVariations.w700,
                                    color: const Color(0xFF1A1B28),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: Color(0xffF4CA12),
                                  ),
                                  rating == "null"
                                      ? const Text(
                                          '0',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : Text(
                                          rating.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        )
                                ],
                              )
                            ],
                          ),
                        ),
                        FavButton(
                          name: name,
                          image: image,
                          placeId: placeId,
                          type: type,
                          distance: distance,
                          walkingTime: walkingTime,
                          rating: rating,
                          address: address,
                        )
                        // InkWell(
                        //   onTap: () {
                        //     // showModalBottomSheet(
                        //     //   context: context,
                        //     //   backgroundColor: Colors.white,
                        //     //   isScrollControlled: true,
                        //     //   constraints: BoxConstraints.tightFor(
                        //     //     height: MediaQuery.sizeOf(context).height * 0.6,
                        //     //   ),
                        //     //   shape: const RoundedRectangleBorder(
                        //     //     borderRadius: BorderRadius.vertical(
                        //     //         top: Radius.circular(20)),
                        //     //   ),
                        //     //   builder: (context) {
                        //     //     return const AddToItineraySheet();
                        //     //   },
                        //     // );
                        //
                        //   },
                        //   child: Container(
                        //     width: 35,
                        //     height: 35,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       shape: BoxShape.circle,
                        //       border:
                        //           Border.all(color: const Color(0xffE2E2E2)),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(6.0),
                        //       child: Image.asset(
                        //         isFavorite
                        //             ? 'assets/images/heart.png'
                        //             : 'assets/images/un_heart.png',
                        //         color: isFavorite
                        //             ? Theme.of(context).colorScheme.secondary
                        //             : null,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    LocationRow(
                      address: address,
                    ),
                    DistanceRow(
                      walkingTime: walkingTime,
                      distance: distance,
                    ),
                    // const PeopleRow(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 0,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xffFFE9E9),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(6.0),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    type ?? 'All',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xFFCF5253),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
