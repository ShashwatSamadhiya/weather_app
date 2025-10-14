part of weather_app;

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.weatherRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCurrentWeatherData(
    PositionCoordinates position,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeatherData =
            await weatherRemoteDataSource.getCurrentWeatherData(position);
        return dartz.Right(remoteWeatherData);
      } on ServerException {
        return dartz.Left(ServerException());
      }
    } else {
      return dartz.Left(NetworkException());
    }
  }

  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
    String cityName,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeatherData =
            await weatherRemoteDataSource.getCityWeatherData(cityName);
        return dartz.Right(remoteWeatherData);
      } on ServerException {
        return dartz.Left(ServerException());
      }
    } else {
      return dartz.Left(NetworkException());
    }
  }

  @override
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    PositionCoordinates position,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeatherData =
            await weatherRemoteDataSource.getWeeklyWeather(position);
        return dartz.Right(remoteWeatherData);
      } on ServerException {
        return dartz.Left(ServerException());
      }
    } else {
      return dartz.Left(NetworkException());
    }
  }
}
