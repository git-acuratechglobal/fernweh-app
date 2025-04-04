import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/location_permission/location_screen.dart';
import 'package:fernweh/view/navigation/guest_login/guest_login.dart';
import 'package:fernweh/view/navigation/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/auth_service/auth_service.dart';
import '../../utils/widgets/tutorial_coach_mark.dart';
import 'collections/widgets/my_itenary_screen.dart';
import 'explore/explore_screen.dart';
import 'friends_list/friends_screen.dart';
import 'map/map_screen.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 2;
  PageController pageController = PageController(initialPage: 2);
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();
  GlobalKey keyBottomNavigation4 = GlobalKey();
  GlobalKey keyBottomNavigation5 = GlobalKey();
  @override
  bool get wantKeepAlive => true;

  void _onWillPop() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(authServiceProvider).refreshToken();
      final isLocationAllowed = ref.watch(locationPermissionProvider);
      final isTutorialFinished =
          ref.watch(localStorageServiceProvider).getTutorial() ?? false;
      if (!isTutorialFinished && isLocationAllowed) {
        Future.delayed(const Duration(seconds: 2), createTutorial);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final guest =
        ref.watch(localStorageServiceProvider).getGuestLogin() ?? false;
    final isLocationAllowed = ref.watch(locationPermissionProvider);
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            return;
          }
          _onWillPop();
        },
        child: Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                isLocationAllowed
                    ? const ExploreScreen()
                    : _selectedIndex == 0
                        ? const LocationPermissionScreen()
                        : const SizedBox(),
                isLocationAllowed
                    ? guest == true
                        ? const GuestLogin()
                        : const MyItenaryScreen()
                    : _selectedIndex == 1
                        ? const LocationPermissionScreen()
                        : const SizedBox(),
                isLocationAllowed
                    ? const MapScreen()
                    : _selectedIndex == 2
                        ? const LocationPermissionScreen()
                        : const SizedBox(),
                guest == true ? const GuestLogin() : const FriendsScreen(),
                guest == true ? const GuestLogin() : const Profile()
              ],
            ),
            bottomNavigationBar: Stack(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                        child: SizedBox(
                          key: keyBottomNavigation1,
                          height: 40,
                          width: 40,
                        ),
                      )),
                      Expanded(
                          child: Center(
                        child: SizedBox(
                          key: keyBottomNavigation2,
                          height: 40,
                          width: 40,
                        ),
                      )),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            key: keyBottomNavigation3,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Center(
                        child: SizedBox(
                          key: keyBottomNavigation4,
                          height: 40,
                          width: 40,
                        ),
                      )),
                      Expanded(
                          child: Center(
                        child: SizedBox(
                          key: keyBottomNavigation5,
                          height: 40,
                          width: 40,
                        ),
                      )),
                    ],
                  ),
                ),
                BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  selectedLabelStyle:
                      TextStyle(fontVariations: FVariations.w700, fontSize: 13),
                  items: [
                    BottomNavigationBarItem(
                      // key: keyBottomNavigation1,
                      icon: Image.asset(
                        'assets/images/ex.png',
                        color: const Color.fromARGB(255, 179, 179, 180),
                      ),
                      activeIcon: Image.asset(
                        'assets/images/ex.png',
                        color: const Color(0xff1A72FF),
                      ),
                      label: "Explore",
                      tooltip: "Explore",
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/fav.png',
                        color: const Color.fromARGB(255, 179, 179, 180),
                      ),
                      activeIcon: Image.asset(
                        'assets/images/fav.png',
                        color: const Color(0xff1A72FF),
                      ),
                      label: "Collections",
                      tooltip: "Collections",
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/maps.png',
                        color: const Color.fromARGB(255, 179, 179, 180),
                      ),
                      activeIcon: Image.asset(
                        'assets/images/maps.png',
                        color: const Color(0xff1A72FF),
                      ),
                      label: "Map",
                      tooltip: "Map",
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/profile.png',
                        color: const Color.fromARGB(255, 179, 179, 180),
                      ),
                      activeIcon: Image.asset(
                        'assets/images/profile.png',
                        color: const Color(0xff1A72FF),
                      ),
                      label: "Friends",
                      tooltip: "Friends",
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/images/profile-circle.png',
                        color: const Color.fromARGB(255, 179, 179, 180),
                      ),
                      activeIcon: Image.asset(
                        'assets/images/profile-circle.png',
                        color: const Color(0xff1A72FF),
                      ),
                      label: "Profile",
                      tooltip: "Profile",
                    ),
                  ],
                ),
              ],
            )));
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      opacityShadow: 0.6,
      alignSkip: Alignment.topCenter,
      targets: _createTargets(),
      colorShadow: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      hideSkip: false,
      onFinish: () {
        ref.read(localStorageServiceProvider).setTutorial();
      },
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {},
    )..show(context: context);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "BottomNavigationBarItem",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.only(top: 20),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Text(
                        "This is the ‘Explore’ tab. (It is currently still in development!) Discover new places",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Browse trending spots and personalized recommendations based on your preferences.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Save places directly to your collections for future trips or spontaneous outings.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Filter results by categories, distance, and popularity to find the perfect spot.",
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            controller.next();
                          },
                          child: const Text("Next"))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "BottomNavigationBarItem",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.only(top: 20),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Text(
                        "This is the ‘Collections’ tab. Organize and save your favorite places, as well as share your upcoming travels",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Create custom collections like “Tokyo 2025,” “Weekend foodspotting,” or “Pet-friendly cafes”.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Categorize places as Want to Visit, Visited, or Visited & Liked to keep track of your experiences.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Add personal notes and tags to each place for future reference.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Share collections with friends or collaborate on trip planning together.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Share your travel dates and see who will also be at the same destination.",
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            controller.next();
                          },
                          child: const Text("Next"))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "BottomNavigationBarItem",
        keyTarget: keyBottomNavigation3,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.only(top: 20),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Text(
                        "This is the ‘Map’ tab. Visualize your saved places and plan better.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "See all your saved locations pinned on an interactive map.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Text(
                            "Tap on a pin to view details, navigate, or access notes.",
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Filter by categories, collections, or trip dates to focus on what matters.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Plan smarter by seeing how locations fit together geographically.",
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            controller.next();
                          },
                          child: const Text("Next"))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "BottomNavigationBarItem",
        keyTarget: keyBottomNavigation4,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.only(top: 20),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Text(
                        "This is the ‘Friends’ tab. Manage your friends and following lists.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Connect with friends to share recommendations and travel plans.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Browse their saved places, visited locations, and curated collections.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Follow their lists or collaborate on shared itineraries.",
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            controller.next();
                          },
                          child: const Text("Next"))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "BottomNavigationBarItem",
        keyTarget: keyBottomNavigation5,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.only(top: 20),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Text(
                        "This is the ‘Profile’ tab. Everything about you.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Customize your profile with home location and interests to get tailored recommendations.",
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• "),
                          Expanded(
                            child: Text(
                              "Manage your account preferences and app settings easily.",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            controller.next();
                          },
                          child: const Text("Next"))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }
}

final locationPermissionProvider =
    StateNotifierProvider<LocationPermissionNotifier, bool>((ref) {
  return LocationPermissionNotifier();
});

class LocationPermissionNotifier extends StateNotifier<bool> {
  LocationPermissionNotifier() : super(false) {
    checkPermission();
  }

  Future<void> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    final isGpsOn = await Geolocator.isLocationServiceEnabled();
    state = !(permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        !isGpsOn);
  }
}
