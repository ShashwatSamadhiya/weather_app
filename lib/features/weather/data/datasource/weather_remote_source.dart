part of weather_app;

abstract class WeatherRemoteDataSource {
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCurrentWeatherData(
    CurrentWeatherApiRouteData position,
  );
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
    CityWeatherApiRouteData cityWeatherApiRouteData,
  );
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    WeeklyWeatherApiRouteData position,
  );
}
