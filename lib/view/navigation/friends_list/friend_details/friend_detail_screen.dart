import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/navigation/friends_list/controller/friends_itinerary_notifier.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/widgets/async_widget.dart';
import '../../../../utils/widgets/image_widget.dart';
import '../../itinerary/notifier/itinerary_notifier.dart';
import '../../itinerary/widgets/my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import '../../itinerary/widgets/my_curated_list/my_curated_list.dart';
import '../add_friend/add_friend_screen.dart';
import '../model/friends.dart';
import '../model/friends_itinerary.dart';

class FriendDetailScreen extends StatelessWidget {
  final bool isAddFriend;
  final Friends friends;

  const FriendDetailScreen(
      {super.key, this.isAddFriend = false, required this.friends});

  @override
  Widget build(BuildContext context) {
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
                  child: ImageWidget(
                      url:
                          'http://fernweh.acublock.in/public/${friends.image}')),
            ),
            const SizedBox(height: 16.0),
            Text(
              friends.fullName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontVariations: FVariations.w700,
              ),
            ),
            if (isAddFriend) const SizedBox(height: 16),
            // if (isAddFriend) const AddRequestButton(size: Size(100, 46)),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: AsyncDataWidgetB(
                    dataProvider:
                        getFriendsItineraryListProvider(friends.id ?? 0),
                    dataBuilder: (context, itinerary) {
                      List<FriendsItinerary> filteredList=itinerary.where((e)=>e.type=="1").toList();
                      return itinerary.isEmpty
                          ? const Center(child: Text("No itinerary found!"))
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
                                          title: filteredList[index].name ?? "",
                                          itineraryId: filteredList[index].id ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child:  FriendItineraryList(
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
                        childAspectRatio: 0.85,
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
                    errorBuilder: (error, stack) => Center(
                          child: Text(error.toString()),
                        )),
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

  final FriendsItinerary itinary;
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
