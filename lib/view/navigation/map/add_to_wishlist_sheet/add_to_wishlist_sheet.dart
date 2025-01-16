import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/view/navigation/map/notifier/wish_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/local_storage_service/local_storage_service.dart';
import '../../../../utils/common/extensions.dart';
import '../../../../utils/widgets/image_widget.dart';
import '../../../auth/login/login_screen.dart';
import '../restaurant_detail/restaurant_detail_screen.dart';

class AddToWishlistSheet extends ConsumerStatefulWidget {
  const AddToWishlistSheet({super.key});

  @override
  ConsumerState<AddToWishlistSheet> createState() => _AddToWishlistSheetState();
}

class _AddToWishlistSheetState extends ConsumerState<AddToWishlistSheet> {
  List<String> selectedItems = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishListItem = ref.watch(wishListProvider);
      setState(() {
        selectedItems.add(wishListItem.wishList.last.placeId);
      });
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Added to Quick Save'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wishListItem = ref.watch(wishListProvider);
    final guestUser = ref.watch(localStorageServiceProvider).getGuestLogin();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.clear),
              ),
              Text(
                'Quick Save List',
                style: TextStyle(
                  color: const Color(0xFF1A1B28),
                  fontSize: 20,
                  fontVariations: FVariations.w700,
                ),
              ),
              const SizedBox.square(dimension: 40)
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
            itemCount: wishListItem.wishList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = wishListItem.wishList[index];
              bool isSelected = selectedItems.contains(item.placeId);
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedItems.toggle(item.placeId);
                  });
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: isSelected
                              ? Border.all(
                                  width: 3,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )
                              : null,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: ImageWidget(
                                  url: item.image,
                                )),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Image.asset(
                                isSelected
                                    ? 'assets/images/selected.png'
                                    : 'assets/images/unselected.png',
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      item.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF1A1B28),
                        fontSize: 16,
                        fontVariations: FVariations.w700,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        "Back to Map",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ))),
              const SizedBox().setWidth(20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedItems.isNotEmpty) {
                      if (guestUser == true) {
                        ref
                            .read(localStorageServiceProvider)
                            .clearGuestSession();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          constraints: BoxConstraints.tightFor(
                            height: MediaQuery.sizeOf(context).height * 0.9,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return AddToItineraySheet(
                              locationId: selectedItems[0],
                              locationIds: selectedItems,
                            );
                          },
                        );

                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return  AddToItineraySheet(locationId: locationId,);
                        // }));
                      }
                    }
                  },
                  child: const Text(
                    textAlign: TextAlign.center,
                    "Add to My Collection",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 25),
        //   child: AppButton(
        //     isLoading: false,
        //     onTap: () {
        //       if (selectedItems.isNotEmpty) {
        //         if (guestUser == true) {
        //           ref.read(localStorageServiceProvider).clearGuestSession();
        //           Navigator.pushAndRemoveUntil(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const LoginScreen()),
        //             (Route<dynamic> route) => false,
        //           );
        //         } else {
        //           Navigator.pop(context);
        //           showModalBottomSheet(
        //             context: context,
        //             backgroundColor: Colors.white,
        //             isScrollControlled: true,
        //             constraints: BoxConstraints.tightFor(
        //               height: MediaQuery.sizeOf(context).height * 0.9,
        //             ),
        //             shape: const RoundedRectangleBorder(
        //               borderRadius:
        //                   BorderRadius.vertical(top: Radius.circular(20)),
        //             ),
        //             builder: (context) {
        //               return AddToItineraySheet(
        //                 locationId: selectedItems[0],
        //                 locationIds: selectedItems,
        //               );
        //             },
        //           );
        //
        //           // Navigator.push(context, MaterialPageRoute(builder: (context){
        //           //   return  AddToItineraySheet(locationId: locationId,);
        //           // }));
        //         }
        //       }
        //     },
        //     child: const Text("Add to Itinerary"),
        //   ),
        // ),
        const SizedBox().setHeight(30),
      ],
    );
  }
}
