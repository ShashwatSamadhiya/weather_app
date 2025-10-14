part of weather_app;

abstract class WeatherRepository {
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCurrentWeatherData(
    PositionCoordinates position,
  );

  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
    String cityName,
  );
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    PositionCoordinates position,
  );
}
