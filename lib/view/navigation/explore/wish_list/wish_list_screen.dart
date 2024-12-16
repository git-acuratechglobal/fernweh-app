import 'package:fernweh/view/navigation/map/notifier/wish_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/common/extensions.dart';
import '../../itinerary/widgets/my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import '../../map/restaurant_detail/restaurant_detail_screen.dart';
import '../explore_screen.dart';

class WishListScreen extends ConsumerStatefulWidget {
  const WishListScreen({super.key});

  @override
  ConsumerState<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends ConsumerState<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final wishListData = ref.watch(wishListProvider);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(wishListProvider.notifier).clearSelection();
                },
              ),
              title: Text(
                "Quick Save",
                style: TextStyle(
                  fontVariations: FVariations.w700,
                  color: const Color(0xFF1A1B28),
                  fontSize: 20,
                ),
              ),
              actions: [
                if (wishListData.selectedItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(wishListProvider.notifier)
                                .clearSelection();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                    'Do you want to remove  from Wish List?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(wishListProvider.notifier)
                                          .removeSelectedItems();
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('No'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
            wishListData.wishList.isEmpty
                ? const Center(child: Text("No wish list"))
                : Expanded(
                    child: ListView.separated(
                      itemCount: wishListData.wishList.length,
                      padding: const EdgeInsets.all(15),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12.0),
                      itemBuilder: (context, index) {
                        final wishList = wishListData.wishList[index];
                        bool isSelected = wishListData.selectedItems
                            .contains(wishList.placeId);
                        return GestureDetector(
                          onLongPress: () {
                            ref
                                .read(wishListProvider.notifier)
                                .toggleSelection(wishList.placeId);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ItinerayItem(
                              isSelected: wishListData.selectedItems.isNotEmpty,
                              placeType: wishList.type,
                              name: wishList.name,
                              placeId: wishList.placeId,
                              address: wishList.address,
                              rating: wishList.rating,
                              distance: wishList.distance,
                              url: wishList.image,
                              selection: null,
                              walkTime: wishList.walkingTime,
                              showingInWishList: true,
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class WishListItems extends StatelessWidget {
  const WishListItems({super.key});

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
                  child: Image.asset(
                    'assets/images/dashboard.png',
                    fit: BoxFit.cover,
                  ),
                ),
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
                                "Juliana’s Pizza",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontVariations: FVariations.w700,
                                  color: const Color(0xFF1A1B28),
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: Color(0xffF4CA12),
                                  ),
                                  Text(
                                    '4.5 ',
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              constraints: BoxConstraints.tightFor(
                                height: MediaQuery.sizeOf(context).height * 0.8,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                return const AddToItineraySheet();
                              },
                            );
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xffE2E2E2)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(
                                'assets/images/un_heart.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const LocationRow(
                      address: "",
                    ),
                    const DistanceRow(),
                    const PeopleRow(),
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
              child: Text(
                'CAFE',
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
    );
  }
}
