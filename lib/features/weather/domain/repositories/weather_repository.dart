part of weather_app;

abstract class WeatherRepository {
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCurrentWeatherData(
    PositionCoordinates position, {
    bool doSaveToCache = true,
  });

  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
    String cityName, {
    bool doSaveToCache = true,
  });
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    PositionCoordinates position, {
    bool doSaveToCache = true,
  });
}
