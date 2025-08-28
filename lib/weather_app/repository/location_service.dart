part of weather_app;

abstract class LocationService {
  Future<PositionCoordinates> getCurrentLocation();
}

class LocationServiceImpl implements LocationService {
  @override
  Future<PositionCoordinates> getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationPermissionException();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionException();
      }
      final location = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      return PositionCoordinates(
        latitude: location.latitude,
        longitude: location.longitude,
      );
    } on LocationPermissionException {
      rethrow;
    }
  }
}
