import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/itinerary_model.dart';
import '../my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import '../my_curated_list/my_curated_list.dart';
import 'model/following_model.dart';
import 'notifier/followlist_notifier.dart';

// class FollowingList extends ConsumerStatefulWidget {
//   const FollowingList({super.key});
//
//   @override
//   ConsumerState createState() => _FollowingListState();
// }
//
// class _FollowingListState extends ConsumerState<FollowingList> {
//   @override
//   Widget build(BuildContext context) {
//     return AsyncDataWidgetB(
//         dataProvider: followingNotifierProvider,
//         dataBuilder: (data) {
//           List<Country> countries =
//               convertItinerariesToHierarchy(data.followingFriendsItineraries);
//           return countries.isEmpty
//               ? Center(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("No itinerary found!"),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           minimumSize: const Size(60, 40),
//                         ),
//                         onPressed: () {
//                           ref.invalidate(followingNotifierProvider);
//                         },
//                         child: const Text(
//                           "Refresh",
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//               )
//               : followingWidget(countries,);
//         },
//         errorBuilder: (error, st) => Center(
//               child: Text(error.toString()),
//             ));
//   }
// }
//
// Widget followingWidget(
//     List<Country> countries,) {
//   return StatefulBuilder(
//       builder: (BuildContext context, void Function(void Function()) setState) {
//     return ListView.builder(
//       padding: const EdgeInsets.only(bottom: 60),
//       itemCount: countries.length,
//       itemBuilder: (context, countryIndex) {
//         final country = countries[countryIndex];
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               onTap: () {
//                 setState(() {
//                   // countryExpansionState[countryIndex] = !(countryExpansionState[countryIndex] ?? false);
//                   country.isExpanded = !country.isExpanded;
//                 });
//               },
//               title: Text(
//                 country.name,
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               trailing: IconButton(
//                 icon: Icon(
//                   country.isExpanded ? Icons.remove : Icons.add,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     country.isExpanded = !country.isExpanded;
//                   });
//                 },
//               ),
//             ),
//             if (country.isExpanded)
//               ...country.states.map((state) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0),
//                       child: ListTile(
//                         onTap: () {
//                           setState(() {
//                             state.isExpanded = !state.isExpanded;
//                           });
//                         },
//                         title: Text(
//                           state.name,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(
//                             state.isExpanded ? Icons.remove : Icons.add,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               state.isExpanded = !state.isExpanded;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     if (state.isExpanded)
//                       ...state.cities.map((city) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 25.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ListTile(
//                                 onTap: () {
//                                   setState(() {
//                                     city.isExpanded = !city.isExpanded;
//                                   });
//                                 },
//                                 title: Text(
//                                   city.name,
//                                   style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 trailing: IconButton(
//                                   icon: Icon(
//                                     city.isExpanded ? Icons.remove : Icons.add,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       city.isExpanded = !city.isExpanded;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               if (city.isExpanded)
//                                 ...city.itineraries.map((itinerary) {
//                                   return InkWell(
//                                     onTap: (){
//                                       Navigator.of(context)
//                                           .push(
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ItenaryDetailsScreen(
//                                                 userId: itinerary.userId??0,
//                                                 title: itinerary.name??"",
//                                                 itineraryId:
//                                                 itinerary.id ??
//                                                     0,
//                                               ),
//                                         ),
//                                       );
//                                     },
//                                     child: MyCreatedItinerary(
//                                       isEditAccess: false,
//                                       placeCount: itinerary.placesCount ?? 0,
//                                       itinary: itinerary,
//                                       editList: const [],
//                                       viewOnly: const [],
//                                       placeUrls: itinerary.placesUrls,
//                                     ),
//                                   );
//                                 }),
//                             ],
//                           ),
//                         );
//                       }),
//                   ],
//                 );
//               }),
//           ],
//         );
//       },
//     );
//   });
// }

class FollowingList extends ConsumerStatefulWidget {
  const FollowingList({super.key});

  @override
  ConsumerState createState() => _FollowingListState();
}

class _FollowingListState extends ConsumerState<FollowingList> {
  @override
  Widget build(BuildContext context) {
    return AsyncDataWidgetB(
        dataProvider: followingNotifierProvider,
        dataBuilder: (data) {
          if (data.followingItineraries.isEmpty &&
              data.followingFriendsItineraries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No itineraries found!"),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(60, 40),
                    ),
                    onPressed: () {
                      ref.invalidate(followingNotifierProvider);
                    },
                    child: const Text(
                      "Refresh",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              if (data.followingItineraries.isNotEmpty)
                ExpansionTile(
                    shape: const Border(),
                    initiallyExpanded: true,
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    title: const Text(
                      "Following Itinerary List",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        shrinkWrap: true,
                        itemCount: data.followingItineraries.length,
                        itemBuilder: (context, index) {
                          final itinary = data.followingItineraries[index];
                          return Column(
                            key: ValueKey('${itinary.id ?? 'no-id'}-$index'),
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItenaryDetailsScreen(
                                        userId: itinary.userId ?? 0,
                                        title: itinary.name ?? "",
                                        itineraryId: itinary.id ?? 0,
                                      ),
                                    ),
                                  );
                                },
                                child: MyCreatedItinerary(
                                  ownerName: itinary.ownerFullName,
                                  isEditAccess: false,
                                  placeCount: itinary.placesCount ?? 0,
                                  itinary: itinary,
                                  editList: const [],
                                  viewOnly: const [],
                                  placeUrls: itinary.placesUrls,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                        // separatorBuilder:
                        //     (BuildContext context, int index) {
                        //   return const SizedBox(
                        //     height: 10,
                        //   );
                        // },
                      ),
                    ]),
              if (data.followingFriendsItineraries.isNotEmpty)
                ExpansionTile(
                    shape: const Border(),
                    initiallyExpanded: true,
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    title: const Text(
                      "Following Friends Itinerary List",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        shrinkWrap: true,
                        itemCount: data.followingFriendsItineraries.length,
                        itemBuilder: (context, index) {
                          final itinary =
                              data.followingFriendsItineraries[index];
                          return Column(
                            key: ValueKey('${itinary.id ?? 'no-id'}-$index'),
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItenaryDetailsScreen(
                                        userId: itinary.userId ?? 0,
                                        title: itinary.name ?? "",
                                        itineraryId: itinary.id ?? 0,
                                      ),
                                    ),
                                  );
                                },
                                child: MyCreatedItinerary(
                                  isEditAccess: false,
                                  placeCount: itinary.placesCount ?? 0,
                                  itinary: itinary,
                                  editList: const [],
                                  viewOnly: const [],
                                  placeUrls: itinary.placesUrls,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                        // separatorBuilder:
                        //     (BuildContext context, int index) {
                        //   return const SizedBox(
                        //     height: 10,
                        //   );
                        // },
                      ),
                    ]),
            ],
          );
        },
        errorBuilder: (error, st) => Center(
              child: ErrorCustomWidget(
                error: error,
                onRetry: () {
                  ref.invalidate(followingNotifierProvider);
                },
              ),
            ));
  }
}
