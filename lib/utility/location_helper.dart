import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Position? position;

  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  static Stream<Position> getPositionStream() => Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          distanceFilter: 10,
        ),
      );

  static Future<Position> getPosition() async {
    if (position != null) {
      return position!;
    }
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const PermissionDeniedException(
            'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    position = await Geolocator.getCurrentPosition();
    return position!;
  }
}
