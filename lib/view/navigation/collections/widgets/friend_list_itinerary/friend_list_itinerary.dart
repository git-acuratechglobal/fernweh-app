import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../utils/widgets/async_widget.dart';
import '../following_list/model/following_model.dart';
import '../my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import '../my_curated_list/my_curated_list.dart';
import 'friend_list_notifier/friend_list_notifier.dart';

class FriendsItineraryList extends ConsumerStatefulWidget {
  const FriendsItineraryList({super.key});

  @override
  ConsumerState createState() => _FriendsItineraryListState();
}

class _FriendsItineraryListState extends ConsumerState<FriendsItineraryList> {
  @override
  Widget build(BuildContext context) {
    return AsyncDataWidgetB(
        dataProvider: getFriendListItineraryProvider,
        dataBuilder: (data) {
          data.removeWhere((e)=>e.name=="Default list");
          List<Country> countries = convertItinerariesToHierarchy(data);
          return countries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No collections found!"),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(60, 40),
                        ),
                        onPressed: () {
                          ref.invalidate(getFriendListItineraryProvider);
                        },
                        child: const Text(
                          "Refresh",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )
              : followingWidget(
                  countries,
                );
        },
        errorBuilder: (error, st) => Center(
              child: Column(
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
                      ref.invalidate(getFriendListItineraryProvider);
                    },
                    child: const Text(
                      "Refresh",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ));
  }
}

Widget followingWidget(
  List<Country> countries,
) {
  return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 60),
      itemCount: countries.length,
      itemBuilder: (context, countryIndex) {
        final country = countries[countryIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  // countryExpansionState[countryIndex] = !(countryExpansionState[countryIndex] ?? false);
                  country.isExpanded = !country.isExpanded;
                });
              },
              title: Text(
                country.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                icon: Icon(
                  country.isExpanded ? Icons.remove : Icons.add,
                ),
                onPressed: () {
                  setState(() {
                    country.isExpanded = !country.isExpanded;
                  });
                },
              ),
            ),
            if (country.isExpanded)
              ...country.states.map((state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            state.isExpanded = !state.isExpanded;
                          });
                        },
                        title: Text(
                          state.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            state.isExpanded ? Icons.remove : Icons.add,
                          ),
                          onPressed: () {
                            setState(() {
                              state.isExpanded = !state.isExpanded;
                            });
                          },
                        ),
                      ),
                    ),
                    if (state.isExpanded)
                      ...state.cities.map((city) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    city.isExpanded = !city.isExpanded;
                                  });
                                },
                                title: Text(
                                  city.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    city.isExpanded ? Icons.remove : Icons.add,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      city.isExpanded = !city.isExpanded;
                                    });
                                  },
                                ),
                              ),
                              if (city.isExpanded)
                                ...city.itineraries.map((itinerary) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ItenaryDetailsScreen(
                                            userId: itinerary.userId ?? 0,
                                            title: itinerary.name ?? "",
                                            itineraryId: itinerary.id ?? 0,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: MyCreatedItinerary(
                                        ownerName: itinerary.ownerFullName,
                                        isEditAccess: false,
                                        placeCount: itinerary.placesCount ?? 0,
                                        itinary: itinerary,
                                        editList: const [],
                                        viewOnly: const [],
                                        placeUrls: itinerary.placesUrls,
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                        );
                      }),
                  ],
                );
              }),
          ],
        );
      },
    );
  });
}
