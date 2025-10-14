part of weather_app;

class GetWeeklyWeather
    implements WeatherUseCase<WeeklyWeatherData, WeatherParams> {
  final WeatherRepository repository;

  GetWeeklyWeather(this.repository);
  @override
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> call(
    WeatherParams params,
  ) async {
    return await repository.getWeeklyWeather(params.coordinates);
  }
}
