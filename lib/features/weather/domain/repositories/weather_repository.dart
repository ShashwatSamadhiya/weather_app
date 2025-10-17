part of weather_app;

abstract class WeatherRepository {
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCurrentWeatherData(
    CurrentWeatherApiRouteData currentWeatherApiRouteData,
  );

  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
    CityWeatherApiRouteData cityWeatherApiRouteData,
  );
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    WeeklyWeatherApiRouteData weeklyWeatherApiRouteData,
  );
}
