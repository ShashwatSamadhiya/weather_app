part of weather_app;

class CurrentWeatherApiRouteData extends APIRouteData {
  final double latitude;
  final double longitude;
  final bool doSaveToCache;

  CurrentWeatherApiRouteData({
    required this.latitude,
    required this.longitude,
    this.doSaveToCache = true,
  });

  @override
  String get path => '/weather';

  @override
  Map<String, dynamic>? get queryParams => {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'appid': _apiAccessKey,
        'units': 'metric',
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/json',
      };

  @override
  dynamic get body => null;
}
