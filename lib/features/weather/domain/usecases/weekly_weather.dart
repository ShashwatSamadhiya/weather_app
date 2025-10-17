part of weather_app;

class GetWeeklyWeather
    implements WeatherUseCase<WeeklyWeatherData, WeeklyWeatherApiRouteData> {
  final WeatherRepository repository;

  GetWeeklyWeather(this.repository);
  @override
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> call(
    WeeklyWeatherApiRouteData params,
  ) async {
    return await repository.getWeeklyWeather(params);
  }
}
