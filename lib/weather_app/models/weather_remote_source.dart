part of weather_app;

abstract class WeatherRemoteDataSource {
  Future<CurrentWeatherData> getCurrentWeatherData(
    PositionCoordinates position,
  );
  Future<CurrentWeatherData> getCityWeatherData(
    String cityName,
  );
  Future<WeeklyWeatherData> getWeeklyWeather(
    PositionCoordinates position,
  );
  Future<MapLayerData> getMapLayer(
    int x,
    int y,
    int zoom,
    String mapType,
  );
}
