import 'dart:io';
import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/utils/common/app_mixin.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/itinerary_notifier.dart';
import 'package:fernweh/view/navigation/itinerary/widgets/shared_list/shared_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../utils/common/app_button.dart';
import '../../../../utils/common/common.dart';
import '../../../../utils/common/config.dart';
import '../../../auth/signup/profile_setup/create_profile_screen.dart';
import '../models/itinerary_model.dart';
import '../models/states/itinerary_state.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
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
                if (!isEditing && tabIndex == 0)
                  IconButton(
                      onPressed: () {
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

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const CreateItinerary()));
                      },
                      icon: const Icon(Icons.add)),
              ],
            ),
            TabBar(
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
                Tab(child: Text("Shared List")),
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
                      dataBuilder: (context, userItinerary) {
                        final localStorageItinerary = ref
                            .watch(localStorageServiceProvider)
                            .getUserItinerary(
                                userItinerary.userIteneries ?? []);
                        final List<Itenery> filteredList =
                            localStorageItinerary!
                                .where((e) => e.placesCount != 0)
                                .toList();
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
                            : ReorderableListView.builder(
                                padding: const EdgeInsets.all(24),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final itinary = filteredList[index].itinerary;
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
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ItenaryDetailsScreen(
                                                    title: itinary.name ?? "",
                                                    itineraryId:
                                                        itinary.id ?? 0,
                                                  ),
                                                ),
                                              );
                                            default:
                                          }
                                        },
                                        child: MyCreatedItinerary(
                                            placeCount: filteredList[index]
                                                    .placesCount ??
                                                0,
                                            itinary: itinary!,
                                            editList: [
                                              ...?filteredList[index].canEdit,
                                              ...?filteredList[index].canView
                                            ]),
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
                                onReorder: (int oldIndex, int newIndex) {
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
                                      .read(localStorageServiceProvider)
                                      .setUserItinerary(localStorageItinerary);
                                },
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
                      ),
                      loadingBuilder: Skeletonizer(
                        enableSwitchAnimation: true,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(24),
                          itemCount: userItinerarydummyList.length,
                          itemBuilder: (context, index) {
                            return MyCreatedItinerary(
                              placeCount: 0,
                              itinary: userItinerarydummyList[index],
                              editList: const [],
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
                  SharedListTab(isMapView: mapView)
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
                child: ImageWidget(
                    url: "http://fernweh.acublock.in/public/${avtar.image}")),
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
          Common.showSnackBar(context, error.toString());
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(validatorsProvider);
    final state = ref.watch(userItineraryNotifierProvider);
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
          Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 24, bottom: 8, right: 24),
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
            padding:
                const EdgeInsets.only(top: 5, left: 24, right: 24, bottom: 10),
            child: Text(
              "Upload Photo",
              style: TextStyle(
                fontVariations: FVariations.w700,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 24, right: 24, bottom: 10),
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
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
  }
}
