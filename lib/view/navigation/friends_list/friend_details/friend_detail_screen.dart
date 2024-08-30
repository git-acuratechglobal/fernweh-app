import 'package:fernweh/utils/common/extensions.dart';
import 'package:flutter/material.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/widgets/async_widget.dart';
import '../../itinerary/notifier/itinerary_notifier.dart';
import '../../itinerary/widgets/my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import '../../itinerary/widgets/my_curated_list/my_curated_list.dart';
import '../add_friend/add_friend_screen.dart';

class FriendDetailScreen extends StatelessWidget {
  final bool isAddFriend;
  final ({String image, String title}) user;

  const FriendDetailScreen(this.user, {super.key, this.isAddFriend = false});

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
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/trash.png'),
                ),
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
              child: ClipOval(child: Image.asset(user.image)),
            ),
            const SizedBox(height: 16.0),
            Text(
              user.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontVariations: FVariations.w700,
              ),
            ),
            const SizedBox(height: 4.0),
            const Text(
              '4 Iternerary',
              style: TextStyle(
                color: Color(0xFF505050),
                fontSize: 16,
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
                    dataProvider: getUserItineraryProvider,
                    dataBuilder: (context, userItinerary) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: userItinerary.userIteneries!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final itinary = userItinerary.userIteneries![index].itinerary;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ItenaryDetailsScreen(
                                      title: itinary.name ?? "",itineraryId: 0,),
                                ),
                              );
                            },
                            child: MyCuratedListTab(
                              itinary: itinary!,
                              isEditing: false,
                              isSelected: false,
                            ),
                          );
                        },
                      );
                    },
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
