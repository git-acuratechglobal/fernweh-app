import 'package:fernweh/view/navigation/map/add_to_wishlist_sheet/add_to_wishlist_sheet.dart';
import 'package:fernweh/view/navigation/map/notifier/wish_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavButton extends ConsumerStatefulWidget {
  const FavButton({
    super.key,
    this.placeId,
    this.name,
    this.image,
  });

  final String? placeId;
  final String? name;
  final String? image;

  @override
  ConsumerState<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends ConsumerState<FavButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final wishList = ref.watch(wishListProvider);
    return InkWell(
      onTap: () {
        if (widget.name != null &&
            widget.placeId != null &&
            widget.image != null) {
          ref.read(wishListProvider.notifier).addToItinerary(WishList(
              name: widget.name ?? "",
              image: widget.image ?? "",
              placeId: widget.placeId ?? ""));
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.sizeOf(context).height * 0.8,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return const AddToWishlistSheet();
            },
          );
          setState(() {

          });
        }
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xffE2E2E2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: wishList.any((e)=>e.placeId==widget.placeId)
              ? Image.asset(
                  'assets/images/heart.png',
                  color: const Color(0xffCF5253),
                )
              : Image.asset(
                  'assets/images/un_heart.png',
                ),
        ),
      ),
    );
  }
}
