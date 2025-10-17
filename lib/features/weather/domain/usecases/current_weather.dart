part of weather_app;

class GetCurrentWeatherData
    implements WeatherUseCase<CurrentWeatherData, CurrentWeatherApiRouteData> {
  final WeatherRepository repository;

  GetCurrentWeatherData(this.repository);
  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>> call(
    CurrentWeatherApiRouteData params,
  ) async {
    return await repository.getCurrentWeatherData(
      params,
    );
  }
}
