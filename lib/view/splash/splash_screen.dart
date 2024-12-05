import 'dart:async';
import 'package:fernweh/utils/common/common.dart';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/auth/login/login_screen.dart';
import 'package:fernweh/view/navigation/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/local_storage_service/local_storage_service.dart';
import '../../utils/common/config.dart';
import '../location_permission/location_service.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final locationPermissionStatus = await Geolocator.checkPermission();
        if (locationPermissionStatus == LocationPermission.denied ||
            locationPermissionStatus == LocationPermission.deniedForever) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LocationPermissionScreen(),
              ),
            );
          });
          return;
        }
        await ref.read(currentPositionProvider.future);
        Future.delayed(const Duration(seconds: 3), () {
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
        });
      } catch (e) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const LocationPermissionScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: Config.backgroundGradient),
        child: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen>
    with WidgetsBindingObserver {
  late Timer _locationPermissionTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _locationPermissionTimer =
        Timer.periodic((const Duration(seconds: 1)), (timer) async {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        _locationPermissionTimer.cancel();
        await ref.read(currentPositionProvider.future);
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
    });
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  Config.locationText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                   await  _handleAppPermission(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text('Enable Location'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _handleAppPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
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
        await openAppSettings();
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

        await openAppSettings();
      }
      return;
    }
  }


}
