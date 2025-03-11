import 'package:fernweh/view/navigation/map/notifier/category_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../navigation/explore/notifier/explore_notifier.dart';

part 'location_service.g.dart';

class LocationService {
  bool _isLocationPermissionGranted = false;

  bool get isLocationPermissionGranted => _isLocationPermissionGranted;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    _isLocationPermissionGranted = true;
    return await Geolocator.getCurrentPosition();
  }


  Future<String> getAddressFromPosition(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];
      return '${placemark.name}, ${placemark.locality}, ${placemark.country}';
    }
    return 'No address available';
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

@riverpod
class CurrentPosition extends _$CurrentPosition {
  @override
  FutureOr<Position> build() async {
    final locationService = ref.watch(locationServiceProvider);
    final Position position = await locationService.getCurrentLocation();
    ref.read(positionProvider.notifier).updatePosition(position);
    ref.invalidate(addressProvider);
    return position;
  }

  Future<void> currentPosition() async {
    final locationService = ref.watch(locationServiceProvider);
    final currentPosition = await locationService.getCurrentLocation();
    ref.read(positionProvider.notifier).updatePosition(currentPosition);
    state = AsyncData(currentPosition);
    ref.invalidate(addressProvider);
    ref.invalidate(itineraryNotifierProvider);
  }

  Future<void> updatePosition(Position position) async {
    state = AsyncData(position);
    ref.read(positionProvider.notifier).updatePosition(position);
    ref.invalidate(addressProvider);
     ref.invalidate(friendsItineraryNotifierProvider);
  }
  Future<void> updatePositionForSearchArea(Position position) async {
    state = AsyncData(position);
    ref.read(positionProvider.notifier).updatePosition(position);
    ref.read(itineraryNotifierProvider.notifier).filteredItinerary();
    ref.invalidate(addressProvider);
  }
}

final positionProvider = StateNotifierProvider<PositionNotifier, Position?>(
    (ref) => PositionNotifier());

class PositionNotifier extends StateNotifier<Position?> {
  PositionNotifier() : super(null);

  void updatePosition(Position? position) {
    if (position != null && (state == null || _isPositionChanged(position))) {
      state = position;
    }
  }

  /// Checks if the new [Position] differs significantly from the current one
  bool _isPositionChanged(Position newPosition) {
    return state?.latitude != newPosition.latitude ||
        state?.longitude != newPosition.longitude;
  }
}

@riverpod
FutureOr<String> address(Ref ref,) async {
  final locationService = ref.read(locationServiceProvider);
  final Position position = await locationService.getCurrentLocation();
  return await locationService.getAddressFromPosition(position);
}




// class PermissionNotifier extends StateNotifier<PermissionStatus> {
//   PermissionNotifier() : super(PermissionStatus.denied);
//
//   Future<void> checkPermission() async {
//     final status = await Permission.locationWhenInUse.status;
//     state = status;
//   }
//
//   Future<void> requestPermission() async {
//     final status = await Permission.locationWhenInUse.request();
//     state = status;
//   }
// }
//
// final permissionProvider = StateNotifierProvider<PermissionNotifier, PermissionStatus>(
//       (ref) => PermissionNotifier(),
// );
