part of weather_app;

class GetCityWeather
    implements WeatherUseCase<CurrentWeatherData, CityWeatherApiRouteData> {
  final WeatherRepository repository;

  GetCityWeather(this.repository);
  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>> call(
    CityWeatherApiRouteData params,
  ) async {
    return await repository.getCityWeatherData(params);
  }
}
