import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/utils/common/app_mixin.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/utils/widgets/loading_widget.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/navigation/friends_list/model/friends.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/all_friends_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/full_address_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/itinerary_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/trip_notifier/create_trip_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/trip_notifier/trip_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/following_list/following.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/following_list/notifier/followlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stepper_list_view/stepper_list_view.dart';
import '../../../../utils/common/app_button.dart';
import '../../../../utils/common/common.dart';
import '../../../../utils/common/config.dart';
import '../../../../utils/widgets/search_places_widget.dart';
import '../../../auth/signup/profile_setup/create_profile_screen.dart';
import '../../friends_list/friend_details/friend_detail_screen.dart';
import '../../profile/profile.dart';
import '../models/itinerary_model.dart';
import '../models/states/itinerary_state.dart';
import '../models/trip/trip.dart';
import 'my_curated_list/curated_list_item_view/itenary_details_screen.dart';
import 'my_curated_list/my_curated_list.dart';

class MyItenaryScreen extends ConsumerStatefulWidget {
  const MyItenaryScreen({super.key});

  @override
  ConsumerState<MyItenaryScreen> createState() => _MyItenaryScreenState();
}

class _MyItenaryScreenState extends ConsumerState<MyItenaryScreen>
    with SingleTickerProviderStateMixin {
  bool isEditing = false;
  late TabController tabController;
  int tabIndex = 0;
  bool mapView = false;
  int? selectedTabIndex;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDetailProvider);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                "My Itinerary",
                style: TextStyle(
                  fontVariations: FVariations.w700,
                  color: const Color(0xFF1A1B28),
                  fontSize: 20,
                ),
              ),
              actions: [
                if (isEditing && tabIndex == 0)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                  ),
                // if (!isEditing && tabIndex == 0) const ShareIcon(),
                // if (!isEditing && tabIndex == 0)
                // IconButton(
                //     onPressed: () {
                //       showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return Dialog(
                //             child: SizedBox(
                //               height: 240,
                //               child: Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 40),
                //                 child: Center(
                //                   child: Column(
                //                     mainAxisSize: MainAxisSize.min,
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     children: [
                //                       const SizedBox(
                //                         height: 20,
                //                       ),
                //                       OutlinedButton(
                //                           onPressed: () {
                //                             Navigator.pop(context);
                //                             showModalBottomSheet(
                //                               context: context,
                //                               backgroundColor: Colors.white,
                //                               isScrollControlled: true,
                //                               constraints:
                //                                   BoxConstraints.tightFor(
                //                                 height:
                //                                     MediaQuery.sizeOf(context)
                //                                             .height *
                //                                         0.8,
                //                               ),
                //                               shape:
                //                                   const RoundedRectangleBorder(
                //                                 borderRadius:
                //                                     BorderRadius.vertical(
                //                                         top: Radius.circular(
                //                                             20)),
                //                               ),
                //                               builder: (context) {
                //                                 return const AddTripSheet();
                //                               },
                //                             );
                //                           },
                //                           child: const Text('New Trip')),
                //                       const SizedBox(
                //                         height: 30,
                //                       ),
                //                       OutlinedButton(
                //                           onPressed: () {
                //                             Navigator.pop(context);
                //                             showModalBottomSheet(
                //                               context: context,
                //                               backgroundColor: Colors.white,
                //                               isScrollControlled: true,
                //                               constraints:
                //                                   BoxConstraints.tightFor(
                //                                 height:
                //                                     MediaQuery.sizeOf(context)
                //                                             .height *
                //                                         0.9,
                //                               ),
                //                               shape:
                //                                   const RoundedRectangleBorder(
                //                                 borderRadius:
                //                                     BorderRadius.vertical(
                //                                         top: Radius.circular(
                //                                             20)),
                //                               ),
                //                               builder: (context) {
                //                                 return const CreateItinerary();
                //                               },
                //                             );
                //                           },
                //                           child: const Text('New Itinerary')),
                //                       Center(
                //                         child: TextButton(
                //                           onPressed: () =>
                //                               Navigator.pop(context),
                //                           child: const Text('Cancel'),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           );
                //         },
                //       );
                //     },
                //     icon: const Icon(Icons.add)),
                PopupMenuButton(
                  icon: const Icon(Icons.add),
                  itemBuilder: (BuildContext context) {
                    return [
                      'New Trip',
                      'New Itinerary',
                    ].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (value) {
                    switch (value) {
                      case "New Trip":
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          constraints: BoxConstraints.tightFor(
                            height: MediaQuery.sizeOf(context).height * 0.8,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return const AddTripSheet();
                          },
                        );
                      case "New Itinerary":
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
                            return const CreateItinerary();
                          },
                        );
                      default:
                    }
                  },
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Trips",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AsyncDataWidgetB(
                      dataProvider: getTripProvider,
                      dataBuilder: (data) {
                        data.sort(
                            (a, b) => a.createdAt!.compareTo(b.createdAt!));
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 15,
                            children: List.generate(data.length + 1, (index) {
                              bool isSelected = selectedTabIndex == index;

                              if (index == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   if (selectedTabIndex == index) {
                                    //     selectedTabIndex = null;
                                    //   } else {
                                    //     selectedTabIndex = index;
                                    //     showModalBottomSheet(
                                    //       context: context,
                                    //       backgroundColor: Colors.white,
                                    //       isScrollControlled: true,
                                    //       constraints: BoxConstraints.tightFor(
                                    //         height:
                                    //         MediaQuery
                                    //             .sizeOf(context)
                                    //             .height *
                                    //             0.8,
                                    //       ),
                                    //       shape: const RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.vertical(
                                    //             top: Radius.circular(20)),
                                    //       ),
                                    //       builder: (context) {
                                    //         return  ViewTripSheet(Trip:tripList ,);
                                    //       },
                                    //     );
                                    //   }
                                    // });
                                  },
                                  child: Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.language_outlined,
                                          size: 30,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )),
                                );
                              }
                              final trip = data[index - 1];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedTabIndex == index) {
                                          selectedTabIndex = null;
                                        } else {
                                          selectedTabIndex = index;
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.white,
                                            isScrollControlled: true,
                                            constraints:
                                                BoxConstraints.tightFor(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.8,
                                            ),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                            ),
                                            builder: (context) {
                                              return ViewTripSheet(
                                                tripId: trip.id ?? 0,
                                              );
                                            },
                                          ).then((val) => setState(() {
                                                selectedTabIndex = null;
                                              }));
                                        }
                                      });
                                    },
                                    child: Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  trip.goingTo ?? "",
                                                  style: TextStyle(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ))),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    trip.formattedDate,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              );
                            }),
                          ),
                        );
                      },
                      errorBuilder: (error, st) => const SizedBox.shrink(),
                      loadingBuilder: Skeletonizer(
                          enableSwitchAnimation: true,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 15,
                              children: List.generate(5, (index) {
                                return Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.language_outlined,
                                        size: 35,
                                        color: Colors.black,
                                      ),
                                    ));
                              }),
                            ),
                          )),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 20, left: 5),
                //   child: Column(
                //     children: [
                //       Container(
                //           height: 55,
                //           width: 55,
                //           decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(30)),
                //           child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: IconButton(
                //                   onPressed: () {},
                //                   icon: const Icon(
                //                     Icons.add_circle,
                //                     color: Colors.black,
                //                   )))),
                //       const SizedBox(
                //         height: 5,
                //       ),
                //       const Text(
                //         "Add more",
                //         style: TextStyle(
                //             fontSize: 10, fontWeight: FontWeight.w500),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TabBar(
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              controller: tabController,
              labelColor: Theme.of(context).colorScheme.secondary,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 40),
              dividerColor: const Color(0xffE2E2E2),
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelStyle: TextStyle(
                fontFamily: "Plus Jakarta Sans",
                fontSize: 15,
                fontVariations: FVariations.w500,
              ),
              labelStyle: TextStyle(
                fontFamily: "Plus Jakarta Sans",
                fontSize: 15,
                fontVariations: FVariations.w700,
              ),
              tabs: const [
                Tab(child: Text("My Curated List")),
                Tab(child: Text("Following")),
                Tab(child: Text("Friend List")),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  RefreshIndicator(
                    color: const Color(0xffCF5253),
                    edgeOffset: 10,
                    onRefresh: () async {
                      ref.invalidate(getUserItineraryProvider);
                    },
                    child: AsyncDataWidgetB(
                      dataProvider: getUserItineraryProvider,
                      dataBuilder: (userItinerary) {
                        final localStorageItinerary = ref
                            .watch(localStorageServiceProvider)
                            .getUserItinerary(
                                userItinerary.userItinerary.userIteneries ??
                                    []);
                        final List<Itenery> filteredList =
                            localStorageItinerary!;
                        List<Itenery>? sharedIteneries = userItinerary
                            .userItinerary.sharedIteneries
                            ?.where((e) =>
                                e.canEdit?.any((i) => i.id == user?.id) ??
                                false)
                            .toList();
                        final localCollaborateList = ref
                            .watch(localStorageServiceProvider)
                            .getCollaborateList(sharedIteneries ?? []);
                        return filteredList.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("No user Itineraries found"),
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
                                            getUserItineraryProvider);
                                      },
                                      child: const Text(
                                        "Refresh",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  ExpansionTile(
                                      shape: const Border(),
                                      initiallyExpanded: true,
                                      tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      title: const Text(
                                        "My List",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      children: [
                                        ReorderableListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(24),
                                          shrinkWrap: true,
                                          itemCount: filteredList.length,
                                          itemBuilder: (context, index) {
                                            final itinary =
                                                filteredList[index].itinerary;
                                            return Column(
                                              key: ValueKey(
                                                  '${itinary?.id ?? 'no-id'}-$index'),
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    switch (isEditing) {
                                                      case true:
                                                        null;

                                                      case false:
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ItenaryDetailsScreen(
                                                              title: itinary
                                                                      .name ??
                                                                  "",
                                                              itineraryId:
                                                                  itinary.id ??
                                                                      0,
                                                            ),
                                                          ),
                                                        );
                                                      default:
                                                    }
                                                  },
                                                  child: MyCreatedItinerary(
                                                    isEditAccess: true,
                                                    placeCount:
                                                        filteredList[index]
                                                                .placesCount ??
                                                            0,
                                                    itinary: itinary!,
                                                    editList:
                                                        filteredList[index]
                                                            .canEdit!,
                                                    viewOnly:
                                                        filteredList[index]
                                                            .canView!,
                                                    placeUrls: userItinerary
                                                            .itineraryPhotos[
                                                        itinary.id],
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
                                          onReorder:
                                              (int oldIndex, int newIndex) {
                                            setState(() {
                                              if (newIndex > oldIndex) {
                                                newIndex -= 1;
                                              }

                                              // Reorder the itinerary items
                                              final item = localStorageItinerary
                                                  .removeAt(oldIndex);
                                              localStorageItinerary.insert(
                                                  newIndex, item);
                                            });
                                            ref
                                                .read(
                                                    localStorageServiceProvider)
                                                .setUserItinerary(
                                                    localStorageItinerary);
                                          },
                                        ),
                                      ]),
                                  if (localCollaborateList!.isNotEmpty)
                                    ExpansionTile(
                                        shape: const Border(),
                                        initiallyExpanded: true,
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 0),
                                        title: const Text(
                                          "Collaborate Lists",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        children: [
                                          ReorderableListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(24),
                                            itemCount:
                                                localCollaborateList.length,
                                            itemBuilder: (context, index) {
                                              final itinary =
                                                  localCollaborateList[index]
                                                      .itinerary;
                                              return Column(
                                                key: ValueKey(
                                                    '${itinary?.id ?? 'no-id'}-$index'),
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      switch (isEditing) {
                                                        case true:
                                                          null;

                                                        case false:
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ItenaryDetailsScreen(
                                                                title: itinary
                                                                        .name ??
                                                                    "",
                                                                itineraryId:
                                                                    itinary.id ??
                                                                        0,
                                                              ),
                                                            ),
                                                          );
                                                        default:
                                                      }
                                                    },
                                                    child: MyCreatedItinerary(
                                                      isEditAccess: true,
                                                      placeCount:
                                                          localCollaborateList[
                                                                      index]
                                                                  .placesCount ??
                                                              0,
                                                      itinary: itinary!,
                                                      editList:
                                                          localCollaborateList[
                                                                  index]
                                                              .canEdit!,
                                                      viewOnly:
                                                          localCollaborateList[
                                                                  index]
                                                              .canView!,
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
                                            onReorder:
                                                (int oldIndex, int newIndex) {
                                              setState(() {
                                                if (newIndex > oldIndex) {
                                                  newIndex -= 1;
                                                }

                                                // Reorder the itinerary items
                                                final item =
                                                    localCollaborateList
                                                        .removeAt(oldIndex);
                                                localCollaborateList.insert(
                                                    newIndex, item);
                                              });
                                              ref
                                                  .read(
                                                      localStorageServiceProvider)
                                                  .setCollaborateList(
                                                      localCollaborateList);
                                            },
                                          ),
                                        ]),
                                ],
                              );
                      },
                      errorBuilder: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(error.toString()),
                            const SizedBox(
                              height: 10,
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                minimumSize: const Size(60, 40),
                              ),
                              onPressed: () {
                                ref.invalidate(getUserItineraryProvider);
                              },
                              child: const Text(
                                "Refresh",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      loadingBuilder: Skeletonizer(
                        enableSwitchAnimation: true,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(24),
                          itemCount: userItinerarydummyList.length,
                          itemBuilder: (context, index) {
                            return MyCreatedItinerary(
                              isEditAccess: false,
                              placeCount: 0,
                              itinary: userItinerarydummyList[index],
                              editList: const [],
                              placeUrls: const [],
                              viewOnly: const [],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // SharedListTab(isMapView: mapView),

                  RefreshIndicator(
                      color: const Color(0xffCF5253),
                      edgeOffset: 10,
                      onRefresh: () async {
                        ref.invalidate(followingNotifierProvider);
                      },
                      child: const FollowingList()),
                  const AllFriends(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarList extends StatelessWidget {
  final List<Can>? images;
  final double? size;
  final double? width;

  const AvatarList({super.key, required this.images, this.size, this.width});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      // physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: images!.length,
      itemBuilder: (BuildContext context, int index) {
        final avtar = images![index];
        return Align(
          widthFactor: 0.75,
          child: Container(
            constraints: BoxConstraints.tight(
              Size.fromRadius(size ?? 17),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: width ?? 2.5, color: Colors.white),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: avtar.imageUrl == null
                    ? UserInitials(
                        fontSize: 14,
                        name: avtar.fullName,
                      )
                    : ImageWidget(url: avtar.imageUrl!)),
          ),
        );
      },
    );
  }
}

class CreateItinerary extends ConsumerStatefulWidget {
  const CreateItinerary({super.key});

  @override
  ConsumerState createState() => _CreateItineraryState();
}

class _CreateItineraryState extends ConsumerState<CreateItinerary>
    with FormUtilsMixin {
  XFile? file;
  int? type = 0;
  List<(String? name, int? type)> typeList = [
    ("Private", 0),
    ("Public", 1),
  ];

  @override
  void initState() {
    ref.listenManual(userItineraryNotifierProvider, (previous, next) {
      switch (next) {
        case UserItineraryCreated() when previous is UserItineraryLoading:
          Navigator.pop(context);
          Common.showSnackBar(context, "UserItinerary created successfully");
        case UserItineraryError(:final error):
          Common.showToast(context: context, message: error.toString());
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(validatorsProvider);
    final state = ref.watch(userItineraryNotifierProvider);
    return AsyncDataWidgetB(
        dataProvider: fullAddressNotifierProvider,
        dataBuilder: (data) {
          return Form(
            key: fkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Add to My Itinerary',
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
                const Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                  child: Text(
                    "Create a new itinerary",
                    style: TextStyle(
                      fontVariations: FVariations.w700,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       top: 12, left: 24, bottom: 8, right: 24),
                //   child: SearchPlacesWidget(
                //     hintText: "Search Country,State or City",
                //     searchController: _searchCountryController,
                //     validator: (val) {
                //       if (val!.isEmpty) {
                //         return "Please select country";
                //       }
                //       return null;
                //     },
                //     onSaved: (val) {
                //       // ref
                //       //     .read(userItineraryNotifierProvider.notifier)
                //       //     .updateForm('location', val);
                //     },
                //     onTap: (val) {
                //       ref
                //           .read(fullAddressNotifierProvider.notifier)
                //           .getFullAddress(placeId: val ?? "");
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 24, bottom: 8, right: 24),
                  child: TextFormField(
                    // controller: itineraryController,
                    decoration: const InputDecoration(
                      hintText: "Enter name",
                    ),
                    onSaved: (val) {
                      ref
                          .read(userItineraryNotifierProvider.notifier)
                          .updateForm('name', val);
                    },
                    validator: (val) => validation.itineraryName(val),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 24, right: 24, bottom: 10),
                  child: Text(
                    "Upload Photo",
                    style: TextStyle(
                      fontVariations: FVariations.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 24, right: 24, bottom: 10),
                  child: GestureDetector(
                    onTap: () async {
                      final pickedImage = await showDialog(
                        context: context,
                        builder: (context) {
                          return const ImagePickerOptions();
                        },
                      );
                      if (pickedImage != null) {
                        setState(() {
                          file = pickedImage;
                        });
                        ref
                            .read(userItineraryNotifierProvider.notifier)
                            .updateForm('image', pickedImage);
                      }
                    },
                    child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        child: switch (file) {
                          XFile image => Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                            ),
                          null => const Icon(Icons.add),
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Image.asset('assets/images/global.png'),
                      const SizedBox(width: 12.0),
                      DropdownButton(
                        value: type,
                        underline: const SizedBox.shrink(),
                        items: typeList.map((e) {
                          return DropdownMenuItem(
                            value: e.$2,
                            child: Text(e.$1.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            type = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppButton(
                      isLoading: state is UserItineraryLoading,
                      onTap: () {
                        if (validateAndSave()) {
                          ref
                              .read(userItineraryNotifierProvider.notifier)
                              .updateForm('type', type);
                          // ref
                          //     .read(userItineraryNotifierProvider.notifier)
                          //     .updateForm('location', data);
                          ref
                              .read(userItineraryNotifierProvider.notifier)
                              .createItinerary();
                        }
                      },
                      child: const Text("Create Itinerary")),
                ),
              ],
            ),
          );
        },
        errorBuilder: (error, st) => Center(
              child: Text(error.toString()),
            ));
  }
}

class AllFriends extends ConsumerStatefulWidget {
  const AllFriends({super.key});

  @override
  ConsumerState<AllFriends> createState() => _AllFriendsState();
}

class _AllFriendsState extends ConsumerState<AllFriends> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncDataWidgetB(
      dataProvider: allFriendsNotifierProvider,
      dataBuilder: (data) {
        // List<Country> countries =
        //     convertItinerariesToHierarchy(data.friendsList);
        return data.friendsList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No itinerary found!"),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(60, 40),
                    ),
                    onPressed: () {
                      ref.invalidate(allFriendsNotifierProvider);
                    },
                    child: const Text(
                      "Refresh",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              )
            :
            // followingWidget(countries, data.itineraryPhotos ?? {});
            ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: data.friendsList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ItenaryDetailsScreen(
                            title: data.friendsList[index].name ?? "",
                            itineraryId: data.friendsList[index].id ?? 0,
                          ),
                        ),
                      );
                    },
                    child: AllFriendsWidget(
                      itinary: data.friendsList[index],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              );
      },
      loadingBuilder: Skeletonizer(
          child: GridView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              ref.invalidate(allFriendsNotifierProvider);
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
}

class AllFriendsWidget extends StatelessWidget {
  const AllFriendsWidget({
    super.key,
    required this.itinary,
  });

  final Itinerary itinary;

  // final int placeCount;
  // final List<Can> editList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 140,
          width: MediaQuery.sizeOf(context).width - 50,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: const Color(0xffE2E2E2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 150,
                width: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageWidget(url: itinary.imageUrl)),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      itinary.name ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontVariations: FVariations.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Text(
                    //   "$placeCount locations",
                    //   style: const TextStyle(
                    //       color: Color(0xFF505050),
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w400),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // const Text(
                    //   'Shared with',
                    //   style: TextStyle(
                    //     color: Color(0xFF505050),
                    //     fontSize: 12,
                    //   ),
                    // ),
                    // Flexible(
                    //   flex: 1,
                    //   child: GestureDetector(onTap: (){
                    //     showModalBottomSheet(
                    //       context: context,
                    //       backgroundColor: Colors.white,
                    //       isScrollControlled: true,
                    //       constraints: BoxConstraints.tightFor(
                    //         height: MediaQuery.sizeOf(context).height * 0.85,
                    //       ),
                    //       shape: const RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    //       ),
                    //       builder: (context) {
                    //         return  UnShareItenarySheet();
                    //       },
                    //     );
                    //
                    //   },child: AvatarList(images: editList)),
                    // )
                    // const Text(
                    //   'Shared with',
                    //   style: TextStyle(
                    //     color: Color(0xFF505050),
                    //     fontSize: 12,
                    //   ),
                    // ),
                    // Flexible(
                    //   flex: 1,
                    //   child: AvatarList(
                    //       images: widget.itinerary.canView!.isEmpty
                    //           ? widget.itinerary.canEdit
                    //           : widget.itinerary.canView),
                    // )
                  ],
                ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     GestureDetector(
              //         onTap: () {
              //           showModalBottomSheet(
              //             context: context,
              //             backgroundColor: Colors.white,
              //             isScrollControlled: true,
              //             constraints: BoxConstraints.tightFor(
              //               height: MediaQuery.sizeOf(context).height * 0.80,
              //             ),
              //             shape: const RoundedRectangleBorder(
              //               borderRadius:
              //               BorderRadius.vertical(top: Radius.circular(20)),
              //             ),
              //             builder: (context) {
              //               return EditItenerary(
              //                 iteneraryPhoto: itinary.imageUrl,
              //                 iteneraryName: itinary.name ?? "",
              //                 id: itinary.id,
              //                 type: int.parse(itinary.type ?? ""),
              //               );
              //             },
              //           );
              //         },
              //         child: Image.asset('assets/images/edit.png')),
              //     const SizedBox(
              //       height: 10,
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         showModalBottomSheet(
              //           context: context,
              //           backgroundColor: Colors.white,
              //           isScrollControlled: true,
              //           constraints: BoxConstraints.tightFor(
              //             height: MediaQuery.sizeOf(context).height * 0.85,
              //           ),
              //           shape: const RoundedRectangleBorder(
              //             borderRadius:
              //             BorderRadius.vertical(top: Radius.circular(20)),
              //           ),
              //           builder: (context) {
              //             return AddNotesSheet(
              //               itineraryId: itinary.id ?? 0,
              //             );
              //           },
              //         );
              //       },
              //       child: Image.asset(
              //         'assets/images/note.png',
              //       ),
              //     ),
              //     ShareIcon(itinary.id.toString())
              //   ],
              // )
            ],
          ),
        ),
      ],
    );
  }
}

class AddTripSheet extends ConsumerStatefulWidget {
  const AddTripSheet({super.key, this.trip});

  final Trip? trip;

  @override
  ConsumerState<AddTripSheet> createState() => _AddTripSheetState();
}

class _AddTripSheetState extends ConsumerState<AddTripSheet> {
  late TextEditingController _tripFieldController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late CleanCalendarController calendarController;
  final _fkey = GlobalKey<FormState>();

  @override
  void initState() {
    _tripFieldController = TextEditingController(
      text: widget.trip?.goingTo,
    );
    calendarController = widget.trip != null
        ? CleanCalendarController(
            initialFocusDate: DateTime.parse(widget.trip?.startDate),
            minDate: DateTime.now(),
            maxDate: DateTime.now().add(const Duration(days: 182)),
            weekdayStart: DateTime.monday,
            initialDateSelected: DateTime.parse(widget.trip?.startDate),
            endDateSelected: DateTime.parse(widget.trip?.endDate))
        : CleanCalendarController(
            minDate: DateTime.now(),
            maxDate: DateTime.now().add(const Duration(days: 182)),
            weekdayStart: DateTime.monday,
          );
    ref.listenManual(createTripNotifierProvider, (previous, next) {
      switch (next) {
        case AsyncData<String?> d when d.value != null:
          ref.invalidate(getTripProvider);
          Navigator.of(context).pop(next);
          Common.showToast(context: context, message: d.value.toString());
        case AsyncError e:
          Common.showToast(context: context, message: e.error.toString());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(createTripNotifierProvider);
    final isEditing = widget.trip != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
        key: _fkey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.clear),
                ),
                Text(
                  isEditing ? 'Edit Trip' : 'Add your Trip',
                  style: TextStyle(
                    color: const Color(0xFF1A1B28),
                    fontSize: 20,
                    fontVariations: FVariations.w700,
                  ),
                ),
                const SizedBox.square(dimension: 40)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SearchPlacesWidget(
              onTap: (val) {},
              hintText: "Search Country,State or City",
              searchController: _tripFieldController,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please select country";
                }
                return null;
              },
              onSaved: (val) {},
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ScrollableCleanCalendar(
                calendarController: calendarController,
                layout: Layout.BEAUTY,
                calendarCrossAxisSpacing: 0,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(),
                  child: const Text("Back"),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: AppButton(
                        isLoading: loading is AsyncLoading,
                        onTap: () {
                          if (_fkey.currentState!.validate()) {
                            _fkey.currentState!.save();
                            ref
                                .read(createTripNotifierProvider.notifier)
                                .updateForm(
                                    startDate:
                                        calendarController
                                            .rangeMinDate!
                                            .toIso8601String()
                                            .split('T')
                                            .first,
                                    endDate: calendarController.rangeMaxDate!
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                    tripPlace:
                                        _tripFieldController.text.trim());
                            if (isEditing) {
                              ref
                                  .read(createTripNotifierProvider.notifier)
                                  .editTrip(tripId: widget.trip?.id ?? 0);
                            } else {
                              ref
                                  .read(createTripNotifierProvider.notifier)
                                  .createTrip();
                            }
                          }
                        },
                        child: Text(isEditing ? "Edit Trip" : "Add new Trip")))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class ViewTripSheet extends ConsumerStatefulWidget {
  const ViewTripSheet({
    super.key,
    required this.tripId,
  });

  final int tripId;

  @override
  ConsumerState<ViewTripSheet> createState() => _ViewTripSheetState();
}

class _ViewTripSheetState extends ConsumerState<ViewTripSheet> {
  Map<String, Map<String, List<Map<String, String>>>>? tripModifiedData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        ref.read(tripDetailProvider.notifier).getTripDetails(widget.tripId);
      });
      ref.listenManual(createTripNotifierProvider, (previous, next) {
        switch (next) {
          case AsyncData<String?> d when d.value != null:
            if (d.value!.contains("Trip deleted successfully")) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ref.invalidate(getTripProvider);

              Common.showToast(context: context, message: d.value.toString());
            }
          case AsyncError e:
            Common.showToast(context: context, message: e.error.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripDetailProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
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
                  'See your Trip',
                  style: TextStyle(
                    color: const Color(0xFF1A1B28),
                    fontSize: 20,
                    fontVariations: FVariations.w700,
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  itemBuilder: (BuildContext context) {
                    return [
                      'Edit Trip',
                      'Delete Trip',
                    ].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (value) {
                    trip.maybeWhen(
                        data: (trip) async {
                          switch (value) {
                            case "Edit Trip":
                              final data = await showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                constraints: BoxConstraints.tightFor(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return AddTripSheet(
                                    trip: trip?.trip,
                                  );
                                },
                              );
                              if (data != null) {
                                Navigator.pop(context);
                              }

                            case "Delete Trip":
                              showDialog<bool>(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                          builder: (context, setState) {
                                            final isLoading=ref.watch(createTripNotifierProvider).isLoading;
                                            print(isLoading);
                                        return AlertDialog(
                                          title: const Text('Are you sure?'),
                                          content: const Text(
                                              'Do you want to delete the Trip?'),
                                          actions: <Widget>[
                                            if (isLoading)
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: LoadingWidget(),
                                              )
                                            else ...[ TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState((){
                                               ref
                                                   .read(
                                                   createTripNotifierProvider
                                                       .notifier)
                                                   .deleteTrip(
                                                   tripId:
                                                   trip?.trip?.id ??
                                                       0);
                                             });
                                              },
                                              child: const Text('Yes'),
                                            ),]
                                          ],
                                        );
                                      }));

                            default:
                          }
                        },
                        orElse: () => null);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncDataWidgetB(
                dataProvider: tripDetailProvider,
                dataBuilder: (tripData) {
                  final friends = tripData?.friendsTrips;
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Based in ${tripData?.trip?.goingTo}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        isScrollControlled: true,
                                        constraints: BoxConstraints.tightFor(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.7,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) {
                                          return ViewFriends(
                                            friends: friends
                                                .map((e) => Friends.fromJson({
                                                      "id": e.userId,
                                                      "image":
                                                          e.friendImage == null
                                                              ? ""
                                                              : e.friendImage
                                                                  .toString(),
                                                      "firstname":
                                                          e.friendFirstName,
                                                      "lastname":
                                                          e.friendLastName
                                                    }))
                                                .toList(),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: friends!.isEmpty
                                          ? [const Text("No friends match")]
                                          : friends.map((friend) {
                                              return Align(
                                                widthFactor: 0.75,
                                                child: Container(
                                                  constraints:
                                                      BoxConstraints.tight(
                                                    const Size.fromRadius(17),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 2.5,
                                                        color: Colors.white),
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: friend
                                                                  .friendImage ==
                                                              null
                                                          ? UserInitials(
                                                              name: friend
                                                                  .fullName,
                                                              fontSize: 14,
                                                            )
                                                          : ImageWidget(
                                                              url:
                                                                  "http://fernweh.acublock.in/public/${friend.friendImage}")),
                                                ),
                                              );
                                            }).toList(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: StateCityToggle(
                            isSelected: (bool isStateSelected) {
                              if (isStateSelected) {
                                setState(() {
                                  tripModifiedData =
                                      tripData?.getDaysByMonthWithFriends(
                                          filterType: 'state');
                                });
                              } else {
                                setState(() {
                                  tripModifiedData =
                                      tripData?.getDaysByMonthWithFriends(
                                          filterType: 'city');
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                            padding: const EdgeInsets.only(left: 15),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final entry = tripModifiedData == null
                                  ? tripData
                                      .getDaysByMonthWithFriends(
                                          filterType: 'city')
                                      .entries
                                      .toList()[index]
                                  : tripModifiedData?.entries.toList()[index];
                              final monthName = entry?.key;
                              final days = entry?.value;
                              final stepperData = days?.entries.map((e) {
                                final day = e.key;
                                final friends = e.value;
                                // print(friends);
                                return StepperItemData(
                                  id: day,
                                  content: {
                                    'day': day,
                                    'friends': friends,
                                  },
                                );
                              }).toList();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    monthName.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  StepperListView(
                                    stepperData: stepperData ?? [],
                                    stepAvatar: (_, data) {
                                      final stepData = data as StepperItemData;
                                      final day =
                                          stepData.content['day'] as String;
                                      return PreferredSize(
                                        preferredSize: const Size(20, 0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            day,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      );
                                    },
                                    stepContentWidget: (_, data) {
                                      final stepData = data as StepperItemData;
                                      final friends =
                                          stepData.content['friends']
                                              as List<Map<String, String>>;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            friends.isEmpty
                                                ? const SizedBox(
                                                    height: 25,
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            Colors.white,
                                                        isScrollControlled:
                                                            true,
                                                        constraints:
                                                            BoxConstraints
                                                                .tightFor(
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.7,
                                                        ),
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        builder: (context) {
                                                          return ViewFriends(
                                                            friends: friends
                                                                .map((e) =>
                                                                    Friends
                                                                        .fromJson({
                                                                      "id": int.parse(
                                                                          e['id']
                                                                              .toString()),
                                                                      "firstname":
                                                                          e['firstName'],
                                                                      "lastname":
                                                                          e['lastName'],
                                                                      "image": e[
                                                                          'image'],
                                                                    }))
                                                                .toList(),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Wrap(
                                                      spacing: 8,
                                                      runSpacing: 10,
                                                      children:
                                                          friends.map((friend) {
                                                        final image =
                                                            friend['image'];
                                                        return Align(
                                                          widthFactor: 0.45,
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints
                                                                    .tight(
                                                              const Size
                                                                  .fromRadius(
                                                                  13),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  width: 2.5,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child: image!
                                                                        .isEmpty
                                                                    ? UserInitials(
                                                                        fontSize:
                                                                            10,
                                                                        name: friend["fullName"] ??
                                                                            "")
                                                                    : ImageWidget(
                                                                        url:
                                                                            "http://fernweh.acublock.in/public/$image")),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                            const Divider()
                                          ],
                                        ),
                                      );
                                    },
                                    stepperThemeData: StepperThemeData(
                                        lineWidth: 30,
                                        lineColor: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                  )
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 0,
                              );
                            },
                            itemCount: tripData!
                                .getDaysByMonthWithFriends()
                                .keys
                                .length),
                      )
                    ],
                  );
                },
                errorBuilder: (error, st) => Center(
                      child: Text(error.toString()),
                    )),
          ),
        ],
      ),
    );
  }
}

class StateCityToggle extends StatefulWidget {
  const StateCityToggle({super.key, required this.isSelected});

  final Function(bool isStateSelected) isSelected;

  @override
  State<StateCityToggle> createState() => _StateCityToggleState();
}

class _StateCityToggleState extends State<StateCityToggle> {
  bool _isStateSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 2)),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isStateSelected = !_isStateSelected;
          });
          widget.isSelected(_isStateSelected);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 82,
              decoration: BoxDecoration(
                color: _isStateSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    bottomLeft: Radius.circular(3)),
              ),
              child: Center(
                  child: Text(
                "City",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _isStateSelected ? Colors.white : Colors.black),
              )),
            ),
            Container(
              height: 40,
              width: 83,
              decoration: BoxDecoration(
                color: _isStateSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3)),
              ),
              child: Center(
                  child: Text(
                "State",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _isStateSelected ? Colors.black : Colors.white),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewFriends extends ConsumerStatefulWidget {
  const ViewFriends({super.key, required this.friends});

  final List<Friends> friends;

  @override
  ConsumerState<ViewFriends> createState() => _ViewFriendsState();
}

class _ViewFriendsState extends ConsumerState<ViewFriends> {
  final searchController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      ref.read(friendViewProvider.notifier).addFriend(widget.friends);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final friends = ref.watch(friendViewProvider);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(hintText: "Search friends"),
                onChanged: (val) {
                  EasyDebounce.debounce(
                    'search-friends',
                    const Duration(seconds: 1),
                    () {
                      ref.read(friendViewProvider.notifier).searchFriends(val);
                    },
                  );
                },
              ),
            ),
            Expanded(
                child: ListView.separated(
              itemCount: friends.filteredList.isEmpty
                  ? friends.originalList.length
                  : friends.filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                final friend = friends.filteredList.isEmpty
                    ? friends.originalList[index]
                    : friends.filteredList[index];
                if (searchController.text.isNotEmpty &&
                    friends.filteredList.isEmpty) {
                  return Center(
                      child: Text(
                          "No result found for ${searchController.text.trim()} "));
                }
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FriendDetailScreen(
                          friends: friend,
                        ),
                      ),
                    );
                  },
                  leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: friend.imageUrl == null
                            ? UserInitials(fontSize: 14, name: friend.fullName)
                            : ImageWidget(url: friend.imageUrl ?? "")),
                  ),
                  title: Text(friend.fullName),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox.shrink();
              },
            ))
          ],
        ));
  }
}

class FriendState {
  final List<Friends> originalList;
  final List<Friends> filteredList;

  FriendState({required this.originalList, required this.filteredList});

  FriendState copyWith({
    List<Friends>? originalList,
    List<Friends>? filteredList,
  }) {
    return FriendState(
      originalList: originalList ?? this.originalList,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}

class FriendsVieNotifier extends StateNotifier<FriendState> {
  FriendsVieNotifier() : super(FriendState(originalList: [], filteredList: []));

  void addFriend(List<Friends> friends) {
    state = state.copyWith(
      originalList: friends,
      filteredList: [],
    );
  }

  void searchFriends(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredList: state.originalList);
    } else {
      final filtered = state.originalList
          .where((friend) =>
              friend.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filteredList: filtered);
    }
  }

  void clearSearch() {
    state = state.copyWith(filteredList: state.originalList);
  }
}

final friendViewProvider =
    StateNotifierProvider<FriendsVieNotifier, FriendState>((ref) {
  return FriendsVieNotifier();
});
