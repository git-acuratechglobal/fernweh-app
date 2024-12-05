import 'dart:async';
import 'package:fernweh/view/auth/auth_provider/auth_provider.dart';
import 'package:fernweh/view/auth/login/login_screen.dart';
import 'package:fernweh/view/navigation/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/local_storage_service/local_storage_service.dart';
import '../../utils/common/config.dart';
import '../location_permission/location_screen.dart';
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
                builder: (context) =>  const LocationPermissionScreen(),
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


