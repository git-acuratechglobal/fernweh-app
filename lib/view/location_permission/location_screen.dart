import 'dart:async';
import 'dart:io';
import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/location_permission/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/common/common.dart';
import '../../utils/common/config.dart';
import '../navigation/navigation_screen.dart';

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
    final isGpsOn= await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always && isGpsOn) {
      await ref.read(currentPositionProvider.future);
      ref.read(locationPermissionProvider.notifier).checkPermission();
    }
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
                      child: const Text("Continue"),
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

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      Common.showSnackBar(context, "Location services are disabled.");

      final shouldOpenSettings = await _showLocationDialog(
        context,
        title: "Location Services Disabled",
        content: "Location services are turned off. Please enable them to use this feature.",
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
      final shouldOpenSettings = await _showLocationDialog(
        context,
        title: "Enable Location Permission",
        content: "To show your location on the map, please enable location access in your device settings."
      );

      if (shouldOpenSettings == true) {
        await Geolocator.openAppSettings();
      }
      return;
    }
  }

  Future<bool?> _showLocationDialog(BuildContext context,
      {required String title, required String content}) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Platform.isAndroid
            ? AlertDialog(
          title: Text(title),
          content: Text(content),
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
        )
            : CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(true),
              isDefaultAction: true,
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

}
