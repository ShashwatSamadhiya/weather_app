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
      print(
          "TESTING: ${DateTime.now()} inside function_onCurrentLocationEvent position: ");
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      print(
          "TESTING: ${DateTime.now()} inside function_onCurrentLocationEvent LocationPermission: $permission ");
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return dartz.Left(LocationPermissionException());
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return dartz.Left(LocationPermissionException());
      }
      print("TESTING: ${DateTime.now()} getting location $permission ");
      final location = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 100,
        ),
      );
      print(
          "TESTING: ${DateTime.now()}locationSettings in getting location: -1 $location");
      return dartz.Right(PositionCoordinates(
        latitude: location.latitude,
        longitude: location.longitude,
      ));
    } on LocationPermissionException {
      print(
          "TESTING:${DateTime.now()} LocationPermissionException in getting location: 0");
      return dartz.Left(LocationPermissionException());
    } catch (e) {
      print(
          "TESTING: ${DateTime.now()} LocationPermissionException in getting location: -1 $e");
      return dartz.Left(LocationPermissionException());
    }
  }
}
