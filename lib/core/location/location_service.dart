part of weather_app;

abstract class LocationService {
  Future<dartz.Either<WeatherAppException, PositionCoordinates>>
      getCurrentLocation();
}

class LocationServiceImpl implements LocationService {
  @override
  Future<dartz.Either<WeatherAppException, PositionCoordinates>>
      getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return dartz.Left(LocationPermissionException());
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return dartz.Left(LocationPermissionException());
      }
      final location = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      return dartz.Right(PositionCoordinates(
        latitude: location.latitude,
        longitude: location.longitude,
      ));
    } on LocationPermissionException {
      return dartz.Left(LocationPermissionException());
    }
  }
}
