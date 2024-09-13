import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fernweh/utils/common/app_button.dart';
import 'package:fernweh/utils/common/app_mixin.dart';
import 'package:fernweh/utils/common/app_validation.dart';
import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/utils/common/config.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/utils/widgets/async_widget.dart';
import 'package:fernweh/utils/widgets/image_widget.dart';
import 'package:fernweh/view/navigation/itinerary/models/states/itinerary_state.dart';
import 'package:fernweh/view/navigation/itinerary/models/states/my_itinerary_state.dart';
import 'package:fernweh/view/navigation/itinerary/notifier/itinerary_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../services/local_storage_service/local_storage_service.dart';
import '../../../auth/login/login_screen.dart';
import '../../../auth/signup/profile_setup/create_profile_screen.dart';
import '../../explore/explore_screen.dart';
import '../../itinerary/models/itinerary_model.dart';
import '../../itinerary/widgets/my_curated_list/my_curated_list.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  const RestaurantDetailScreen({
    super.key,
    this.images,
    this.image,
    this.name,
    this.rating,
    this.address,
    this.distance,
    this.walkingTime,
    this.locationId,
  });

  final List<String>? images;
  final String? image;
  final String? name;
  final String? rating;
  final String? address;
  final String? distance;
  final String? walkingTime;
  final String? locationId;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guest = ref.watch(localStorageServiceProvider).getGuestLogin();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  images == null
                      ? AspectRatio(
                          aspectRatio: 1.3,
                          child: ImageWidget(url: image.toString()))
                      : CarouselSlider(
                          options: CarouselOptions(
                              scrollPhysics: images!.length >= 2
                                  ? null
                                  : const NeverScrollableScrollPhysics(),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 700),
                              aspectRatio: 1.3,
                              viewportFraction: 1,
                              autoPlay: images!.length >= 2,
                              onPageChanged: (val, _) {}),
                          items: images?.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return ImageWidget(url: i);
                              },
                            );
                          }).toList(),
                        ),
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 8,
                    left: 24,
                    right: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                        Row(
                          children: [
                            // Container(
                            //   width: 48,
                            //   height: 48,
                            //   decoration: const BoxDecoration(
                            //     color: Colors.white,
                            //     shape: BoxShape.circle,
                            //   ),
                            //   child: const ShareIcon(""),
                            // ),
                            const SizedBox(width: 16),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/images/heart.png',
                                  color: const Color(0xffCF5253),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    isScrollControlled: true,
                                    constraints: BoxConstraints.tightFor(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.6,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      return AddToItineraySheet(
                                        locationId: locationId,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name ?? '',
                            style: TextStyle(
                              color: const Color(0xFF1A1B28),
                              fontSize: 28,
                              fontVariations: FVariations.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.asset('assets/images/call.png')
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 24,
                          color: Color(0xffF4CA12),
                        ),
                        Text(
                          rating ?? '4.5 ',
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: Config.categories
                          .map((e) => e.title)
                          .take(3)
                          .map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFE9E9),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            e,
                            style: TextStyle(
                              fontVariations: FVariations.w700,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                      style: TextStyle(
                        color: Color(0xFF494D60),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mon-Sat',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontVariations: FVariations.w700,
                                        ),
                                      ),
                                      const Text(
                                        '08:00pm - 09:00pm',
                                        style: TextStyle(
                                          color: Color(0xFF505050),
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      LocationRow(
                                        address: address ?? "",
                                      ),
                                      DistanceRow(
                                        distance: distance,
                                        walkingTime: walkingTime,
                                      ),
                                    ],
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          'assets/images/mapview.png',
                                          fit: BoxFit.cover,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/location.png',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Get Direction',
                              style: TextStyle(
                                color: const Color(0xFFCF5253),
                                fontSize: 16,
                                fontVariations: FVariations.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (guest == true) {
                      ref.read(localStorageServiceProvider).clearGuestSession();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
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
                            locationId: locationId,
                          );
                        },
                      );
                      // Navigator.push(context, MaterialPageRoute(builder: (context){
                      //   return  AddToItineraySheet(locationId: locationId,);
                      // }));
                    }
                  },
                  child: const Text("Add to My Itinerary"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddToItineraySheet extends ConsumerStatefulWidget {
  const AddToItineraySheet({
    super.key,
    this.locationId,
  });

  final String? locationId;

  @override
  ConsumerState<AddToItineraySheet> createState() => _AddToItineraySheetState();
}

class _AddToItineraySheetState extends ConsumerState<AddToItineraySheet>
    with FormUtilsMixin {
  int selectedOption = Config.itinaryOptions[0].id;
  List<(String? name, int? type)> typeList = [
    ("Private", 0),
    ("Public", 1),
  ];
  int? type = 0;
  int? _selectedItinerary;

  XFile? file;
  final itineraryController = TextEditingController();
  bool _isSelected = false;
  String? itineraryId;

  Itenery? itinerary;

  @override
  Widget build(BuildContext context) {
    ref.listen(userItineraryNotifierProvider, (previous, next) {
      switch (next) {
        case UserItineraryCreated(:final itinerary)
            when previous is UserItineraryLoading:
          ref
              .read(localStorageServiceProvider)
              .setItineraryId(itinerary.id!.toInt());
          ref
              .read(myItineraryNotifierProvider.notifier)
              .updateForm('userId', itinerary.id);
          ref
              .read(myItineraryNotifierProvider.notifier)
              .updateForm('intineraryListId', itinerary.id);
          ref
              .read(myItineraryNotifierProvider.notifier)
              .updateForm('locationId', widget.locationId);

          setState(() {
            _isSelected = false;
            itineraryController.clear();
            file = null;
          });
          Common.showSnackBar(context, "UserItinerary created successfully");
        case UserItineraryError(:final error):
          Common.showSnackBar(context, error.toString());
        default:
      }
    });

    ref.listen(myItineraryNotifierProvider, (previous, next) {
      switch (next) {
        case MyItineraryCreatedState() when previous is MyItineraryLoading:
          Common.showSnackBar(context, "Place added in itinerary successfully");
          Navigator.pop(context);
        case MyItineraryErrorState(:final error):
          Common.showSnackBar(context, error.toString());
        default:
      }
    });

    final state = ref.watch(userItineraryNotifierProvider);
    final myItineraryState = ref.watch(myItineraryNotifierProvider);
    final selectedItineraryId =
        ref.watch(localStorageServiceProvider).getItineraryId();
    final validation = ref.watch(validatorsProvider);
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text("Please choose one option"),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10,
                        children: Config.itinaryOptions.map((e) {
                          return Container(
                            width: 140,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                            child: Row(
                              children: [
                                Radio(
                                    activeColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    value: e.id,
                                    groupValue: selectedOption,
                                    onChanged: (_) {
                                      setState(() {
                                        selectedOption = e.id;
                                      });
                                    }),
                                Text(e.name)
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 0),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 24, bottom: 5),
                    child: Text(
                      "My itinerary list",
                      style: TextStyle(
                          fontVariations: FVariations.w700, fontSize: 15),
                    ),
                  ),
                  AsyncDataWidgetB(
                    dataProvider: getUserItineraryProvider,
                    dataBuilder: (context, userItinerary) {
                      return userItinerary.userIteneries!.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("No user Itinerary found"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelected = !_isSelected;
                                        // ref
                                        //     .read(localStorageServiceProvider)
                                        //     .setItineraryId();
                                      });
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: _isSelected
                                                ? Colors.red
                                                : Colors.black12),
                                      ),
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(10),
                              itemCount:
                                  userItinerary.userIteneries!.length + 1,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 25,
                                mainAxisSpacing: 25,
                                childAspectRatio: 0.78,
                              ),
                              itemBuilder: (context, index) {
                                if (index ==
                                    userItinerary.userIteneries!.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 35, right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isSelected = !_isSelected;
                                          // ref
                                          //     .read(localStorageServiceProvider)
                                          //     .setItineraryId();
                                        });
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: _isSelected
                                                  ? Colors.red
                                                  : Colors.black12),
                                        ),
                                        child: const Icon(Icons.add),
                                      ),
                                    ),
                                  );
                                }
                                final itinary =
                                    userItinerary.userIteneries![index];
                                if (selectedItineraryId != null) {
                                  _selectedItinerary = userItinerary
                                      .userIteneries!
                                      .indexWhere((e) =>
                                          e.itinerary!.id ==
                                          selectedItineraryId);
                                  itinerary = userItinerary.userIteneries!
                                      .firstWhere((e) =>
                                          e.itinerary!.id ==
                                          selectedItineraryId);
                                }
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedItinerary = index;
                                    });

                                    ref
                                        .read(localStorageServiceProvider)
                                        .setItineraryId(int.parse(
                                            itinary.itinerary!.id.toString()));
                                  },
                                  child: MyCuratedListTab(
                                      itinary: itinary.itinerary!,
                                      isEditing: false,
                                      isSelected: _selectedItinerary == index),
                                );
                              },
                            );
                    },
                    errorBuilder: (error, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: Text(error.toString())),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSelected = !_isSelected;
                                  // ref
                                  //     .read(localStorageServiceProvider)
                                  //     .setItineraryId();
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: _isSelected
                                          ? Colors.red
                                          : Colors.black12),
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    loadingBuilder: Skeletonizer(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10),
                        itemCount: 6,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Image.asset(
                                "assets/images/amusement.png",
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("dummy text")
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 0),
                  _isSelected
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 24, right: 24),
                              child: Text(
                                "Create a new itinerary",
                                style: TextStyle(
                                  fontVariations: FVariations.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, left: 24, bottom: 8, right: 24),
                              child: TextFormField(
                                controller: itineraryController,
                                decoration: const InputDecoration(
                                  hintText: "Enter name",
                                ),
                                onSaved: (val) {
                                  ref
                                      .read(userItineraryNotifierProvider
                                          .notifier)
                                      .updateForm('name', val);
                                },
                                validator: (val) =>
                                    validation.itineraryName(val),
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
                                        .read(userItineraryNotifierProvider
                                            .notifier)
                                        .updateForm('image', pickedImage);
                                  }
                                },
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12)),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
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
                          ],
                        )
                      : const SizedBox(
                          height: 50,
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppButton(
                      isLoading: _isSelected
                          ? state is UserItineraryLoading
                          : myItineraryState is MyItineraryLoading,
                      onTap: () {
                        if (_isSelected) {
                          if (validateAndSave()) {
                            ref
                                .read(userItineraryNotifierProvider.notifier)
                                .updateForm('type', type);
                            ref
                                .read(userItineraryNotifierProvider.notifier)
                                .createItinerary();
                          }
                        } else {
                          ref
                              .read(myItineraryNotifierProvider.notifier)
                              .updateForm('type', selectedOption);
                          ref
                              .read(myItineraryNotifierProvider.notifier)
                              .updateForm(
                                  'userId', itinerary?.itinerary!.userId);
                          ref
                              .read(myItineraryNotifierProvider.notifier)
                              .updateForm(
                                  'intineraryListId', itinerary?.itinerary!.id);
                          ref
                              .read(myItineraryNotifierProvider.notifier)
                              .updateForm('locationId', widget.locationId);
                          ref
                              .read(myItineraryNotifierProvider.notifier)
                              .createMyItinerary();
                        }
                      },
                      child: _isSelected
                          ? const Text("Create Itinerary")
                          : const Text("Add to itinerary"),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
