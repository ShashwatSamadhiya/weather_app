part of weather_app;

class CityWeatherApiRouteData extends APIRouteData {
  final String cityName;
  final bool doSaveToCache;

  CityWeatherApiRouteData({
    required this.cityName,
    this.doSaveToCache = true,
  });

  @override
  String get path => '/weather';

  @override
  Map<String, dynamic>? get queryParams => {
        'q': cityName,
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
