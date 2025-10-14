part of weather_app;

abstract class WeatherLocalDataSource {
  Future<void> cacheCurrentWeather(
    PositionCoordinates position,
    CurrentWeatherData weatherData,
  );

  Future<void> cacheCityWeather(
    String cityName,
    CurrentWeatherData weatherData,
  );

  Future<void> cacheWeeklyWeather(
    PositionCoordinates position,
    WeeklyWeatherData weatherData,
  );

  Future<CurrentWeatherData?> getLastCurrentWeather(
    PositionCoordinates position,
  );

  Future<CurrentWeatherData?> getLastCityWeather(String cityName);

  Future<WeeklyWeatherData?> getLastWeeklyWeather(
    PositionCoordinates position,
  );
}
