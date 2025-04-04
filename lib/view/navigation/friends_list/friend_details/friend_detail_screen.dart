import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/navigation/friends_list/controller/friends_itinerary_notifier.dart';
import 'package:fernweh/view/navigation/friends_list/controller/friends_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/widgets/async_widget.dart';
import '../../../../utils/widgets/image_widget.dart';
import '../../collections/models/itinerary_model.dart';
import '../../collections/widgets/my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import '../../profile/profile.dart';
import '../model/friends.dart';

class FriendDetailScreen extends ConsumerStatefulWidget {
  final bool isAddFriend;
  final Friends friends;

  const FriendDetailScreen(
      {super.key, this.isAddFriend = false, required this.friends});

  @override
  ConsumerState<FriendDetailScreen> createState() => _FriendDetailScreenState();
}

class _FriendDetailScreenState extends ConsumerState<FriendDetailScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.friends.fullName);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              leadingWidth: 100,
              leading: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Text(
                    "Back",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'unfriend':
                        ref
                            .read(friendListProvider.notifier)
                            .removeFriend(friendId: widget.friends.id ?? 0);
                        Navigator.pop(context);
                        break;
                      case 'report':
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Report Submitted"),
                            content: const Text(
                              "Your request has been forwarded to the Administrator, and will be reviewed.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, // Close confirmation

                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                        ref
                            .read(friendListProvider.notifier)
                            .removeFriend(friendId: widget.friends.id ?? 0);

                        Navigator.of(context).pop();
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'unfriend',
                      child: Text('Unfriend'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'report',
                      child: Text('Report User'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert), // Or any icon you like
                )
              ],
            ),
            Container(
              width: 125,
              height: 125,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: ClipOval(
                  child: widget.friends.imageUrl == null
                      ? UserInitials(name: widget.friends.fullName)
                      : ImageWidget(url: widget.friends.imageUrl.toString())),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.friends.fullName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontVariations: FVariations.w700,
              ),
            ),
            if (widget.isAddFriend) const SizedBox(height: 16),
            // if (isAddFriend) const AddRequestButton(size: Size(100, 46)),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: AsyncDataWidgetB(
                  dataProvider:
                      getFriendsItineraryListProvider(widget.friends.id ?? 0),
                  dataBuilder: (itinerary) {
                    List<Itinerary> filteredList =
                        itinerary.where((e) => e.type == "1").toList();
                    return itinerary.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("No itinerary found!"),
                              const SizedBox(
                                height: 10,
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  minimumSize: const Size(60, 40),
                                ),
                                onPressed: () {
                                  ref.invalidate(
                                      getFriendsItineraryListProvider);
                                },
                                child: const Text(
                                  "Refresh",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: filteredList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 25,
                              mainAxisSpacing: 25,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItenaryDetailsScreen(
                                        userId: filteredList[index].userId ?? 0,
                                        title: filteredList[index].name ?? "",
                                        itineraryId:
                                            filteredList[index].id ?? 0,
                                      ),
                                    ),
                                  );
                                },
                                child: FriendItineraryList(
                                  itinary: filteredList[index],
                                  isEditing: false,
                                  isSelected: false,
                                ),
                              );
                            },
                          );
                  },
                  loadingBuilder: Skeletonizer(
                      child: GridView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xffE2E2E2),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    "assets/images/avatar1.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "dummy name",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  )),
                  errorBuilder: (error, stack) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(error.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(60, 40),
                        ),
                        onPressed: () {
                          ref.invalidate(getFriendsItineraryListProvider);
                        },
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendItineraryList extends StatelessWidget {
  const FriendItineraryList({
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
                  child: GridView.builder(
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
                        if (itinary.placesUrls.isEmpty) {
                          return Container(
                            color: Colors.grey[300],
                          );
                        } else {
                          if (index < itinary.placesUrls.length) {
                            return ImageWidget(url: itinary.placesUrls[index]);
                          } else {
                            return Container(
                              color: Colors.grey[300],
                            );
                          }
                        }
                      }),
                ))),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: Text(
            overflow: TextOverflow.fade,
            itinary.name ?? "",
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
