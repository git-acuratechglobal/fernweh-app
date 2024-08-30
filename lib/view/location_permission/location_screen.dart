import 'package:fernweh/utils/common/extensions.dart';
import 'package:fernweh/view/location_permission/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/local_storage_service/local_storage_service.dart';
import '../../utils/common/config.dart';
import '../navigation/navigation_screen.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen> {
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
                      "This app requires that location services are turned on your device and for this app. You must enable them in settings before using this app.",
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
                      onPressed: () {
                        ref.read(currentPositionProvider);
                        ref
                            .read(localStorageServiceProvider)
                            .clearGuestSession();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const NavigationScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text("Allow"),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 90, 90, 90),
                    ),
                    onPressed: () {},
                    child: const Text("Maybe later"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
