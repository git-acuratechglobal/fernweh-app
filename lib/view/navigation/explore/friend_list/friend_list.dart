import 'package:cached_network_image/cached_network_image.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import '../../../../utils/common/extensions.dart';
import '../../../../utils/common/fav_button.dart';
import '../../../../utils/widgets/loading_widget.dart';
import '../../profile/profile.dart';
import '../explore_screen.dart';

class FriendsListItems extends StatelessWidget {
  const FriendsListItems({
    super.key,
    this.type,
    this.image,
    this.walkingTime,
    this.name,
    this.rating,
    this.distance,
    required this.categoryName,
    required this.address,
    required this.ownerImage,
    required this.ownerName,
  });

  final String? type;
  final String? image;
  final String? walkingTime;
  final String? name;
  final String? rating;
  final String? distance;
  final String categoryName;
  final String address;
  final String? ownerImage;
  final String ownerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.2,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xffE2E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: CachedNetworkImage(
                      imageUrl: image.toString(),
                      // placeholder: (context, url) => const Padding(
                      //       padding: EdgeInsets.all(100.0),
                      //       child: LoadingWidget(),
                      //     ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const Center(child: LoadingWidget()),
                      fit: BoxFit.cover),
                ),
                Positioned(
                  top: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFE9E9),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(6.0),
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        color: const Color(0xFFCF5253),
                        fontSize: 11,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: FavButton(),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                        ),
                        child: ownerImage == null
                            ? UserInitials(
                          fontSize: 14,
                                name: ownerName,
                              )
                            : ClipOval(
                                child: ImageWidget(url: ownerImage!),
                              ),
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        ownerName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontVariations: FVariations.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
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
                                  '0 ',
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
          ),
        ],
      ),
    );
  }
}
