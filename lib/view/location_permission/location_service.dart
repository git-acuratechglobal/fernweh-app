import 'package:fernweh/view/navigation/map/notifier/category_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

class LocationService {
  bool _isLocationPermissionGranted = false;
  bool get isLocationPermissionGranted => _isLocationPermissionGranted;
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openAppSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _isLocationPermissionGranted = true;
    final position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<String> getAddressFromPosition(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];
      return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
    }
    return 'No address available';
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

@Riverpod(keepAlive: true)
class CurrentPosition extends _$CurrentPosition {
  @override
  FutureOr<Position> build() async {
    final locationService = ref.watch(locationServiceProvider);
    final Position position = await locationService.getCurrentLocation();
    ref.read(positionProvider.notifier).update((state) => position);
    return position;
  }

  Future<void> currentPosition() async {
    final locationService = ref.watch(locationServiceProvider);
    final currentPosition = await locationService.getCurrentLocation();
    ref.read(positionProvider.notifier).update((state) => currentPosition);
    state = AsyncData(currentPosition);
    ref.invalidate(addressProvider);
    ref.invalidate(itineraryNotifierProvider);
  }

  Future<void> updatePosition(Position position) async {
    state = AsyncData(position);
    ref.read(positionProvider.notifier).update((state) => position);
    ref.invalidate(addressProvider);
    ref.invalidate(itineraryNotifierProvider);
  }
}

final positionProvider = StateProvider<Position?>((ref) => null);

@Riverpod(keepAlive: true)
FutureOr<String> address(AddressRef ref) async {
  final position = await ref.read(currentPositionProvider.future);
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getAddressFromPosition(position);
}
