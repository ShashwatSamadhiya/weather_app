part of weather_app;

class GetCurrentWeatherData
    implements WeatherUseCase<CurrentWeatherData, WeatherParams> {
  final WeatherRepository repository;

  GetCurrentWeatherData(this.repository);
  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>> call(
    WeatherParams params,
  ) async {
    return await repository.getCurrentWeatherData(params.coordinates);
  }
}
