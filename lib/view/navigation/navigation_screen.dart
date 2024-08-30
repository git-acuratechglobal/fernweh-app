import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/navigation/guest_login/guest_login.dart';
import 'package:fernweh/view/navigation/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'explore/explore_screen.dart';
import 'friends_list/friends_screen.dart';
import 'itinerary/widgets/my_itenary_screen.dart';
import 'map/map_screen.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

void _onWillPop()  {
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
                onPressed: () =>  SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final guest = ref.watch(localStorageServiceProvider).getGuestLogin();
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            return;
          }
          _onWillPop();
        },
        child: Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                const ExploreScreen(),
                guest == true ? const GuestLogin() : const MyItenaryScreen(),
                const MapScreen(),
                guest == true ? const GuestLogin() : const FriendsScreen(),
                guest == true ? const GuestLogin() : const Profile()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  pageController.jumpToPage(index);
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              selectedLabelStyle: TextStyle(
                fontVariations: FVariations.w700,
              ),
              items: [
                BottomNavigationBarItem(
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
                  label: "Itinerary",
                  tooltip: "Itinerary",
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
                  label: "Friends List",
                  tooltip: "Friends List",
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
            )));
  }
}
