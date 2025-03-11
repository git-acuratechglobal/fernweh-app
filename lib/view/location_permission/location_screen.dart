import 'dart:async';

import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/location_permission/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/local_storage_service/local_storage_service.dart';
import '../../utils/common/common.dart';
import '../../utils/common/config.dart';
import '../auth/auth_provider/auth_provider.dart';
import '../auth/login/login_screen.dart';
import '../navigation/navigation_screen.dart';
import '../onboarding/onboarding_screen.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen>  with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationPermission();
    }
  }
  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    final _isGpsOn= await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always && _isGpsOn) {
      await _navigateToNextScreen();
    }
  }
  Future<void> _navigateToNextScreen()async{
   Future.microtask(()async{
     await ref.read(currentPositionProvider.future);
   });
    final onBoarding =
    ref.read(localStorageServiceProvider).getOnboarding();

    final user = ref.read(localStorageServiceProvider).getUser();

    final guest = ref.read(localStorageServiceProvider).getGuestLogin();

    if (onBoarding == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      return;
    }
    if (guest == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NavigationScreen()),
      );
      return;
    }
    if (user == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }
    ref.read(userDetailProvider.notifier).update((state) => user);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const NavigationScreen()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/location_illustration.png'),
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enable your location",
                    style: TextStyle(
                      fontSize: 26,
                      fontVariations: FVariations.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      Config.locationText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 90, 90, 90),
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () async {
                        await  _handleAppPermission(context);
                      },
                      child: const Text("Allow"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> _handleAppPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Common.showSnackBar(context, "Location services are disabled.");
      final shouldOpenSettings = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Services Disabled"),
          content: const Text(
              "Location services are required. Would you like to open settings to enable them?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );

      if (shouldOpenSettings == true) {
        await Geolocator.openLocationSettings();
      }
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Common.showSnackBar(context, "Location permission is denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {

      final shouldOpenSettings = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enable Location Permission"),
          content: const Text(
            "The app requires location permission to function properly. "
                "Please enable location permissions in the app settings.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );

      if (shouldOpenSettings == true) {

        await Geolocator.openAppSettings();
      }
      return;
    }
  }
}
