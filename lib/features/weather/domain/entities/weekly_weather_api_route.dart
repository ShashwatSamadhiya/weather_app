part of weather_app;

class WeeklyWeatherApiRouteData extends APIRouteData {
  final PositionCoordinates position;

  @override
  String get baseApiPath => _weeklyWeatherBaseApiPath;

  WeeklyWeatherApiRouteData({
    required this.position,
  });

  @override
  String get path => '/v1/forecast';

  @override
  Map<String, dynamic>? get queryParams => {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'current': '',
        'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
        'timezone': 'auto',
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/json',
      };

  @override
  dynamic get body => null;
}
