part of weather_app;

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  WeatherAppApiHelper weatherAppApiHelper;
  ApiClient apiClient;

  WeatherRemoteDataSourceImpl({
    required this.weatherAppApiHelper,
    required this.apiClient,
  });

  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCurrentWeatherData(
          CurrentWeatherApiRouteData currentWeatherApiRouteData) async {
    return await weatherAppApiHelper.ensure<CurrentWeatherData>(
      () => apiClient.getRequest(currentWeatherApiRouteData),
      parser: (data) => CurrentWeatherData.fromJson(
        json.decode(data),
      ),
    );
  }

  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
          CityWeatherApiRouteData cityWeatherApiRouteData) async {
    return await weatherAppApiHelper.ensure<CurrentWeatherData>(
      () => apiClient.getRequest(cityWeatherApiRouteData),
      parser: (data) => CurrentWeatherData.fromJson(
        json.decode(data),
      ),
    );
  }

  @override
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    WeeklyWeatherApiRouteData weeklyWeatherApiRouteData,
  ) async {
    return await weatherAppApiHelper.ensure<WeeklyWeatherData>(
      () => apiClient.getRequest(weeklyWeatherApiRouteData),
      parser: (data) => WeeklyWeatherData.fromJson(
        json.decode(data),
      ),
    );
  }
}
