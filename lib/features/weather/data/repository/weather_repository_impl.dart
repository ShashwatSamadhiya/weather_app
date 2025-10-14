part of weather_app;

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  final WeatherLocalDataSource weatherLocalDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.weatherRemoteDataSource,
    required this.weatherLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCurrentWeatherData(
    PositionCoordinates position, {
    bool doSaveToCache = true,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteWeatherData =
            await weatherRemoteDataSource.getCurrentWeatherData(
          position,
        );
        if (doSaveToCache) {
          await weatherLocalDataSource.cacheCurrentWeather(
            position,
            remoteWeatherData,
          );
        }
        return dartz.Right(remoteWeatherData);
      } else {
        throw NetworkException();
      }
    } catch (error, stackTrace) {
      print("getCurrentWeatherData error: $error , stackTrace: $stackTrace");
      try {
        final localData =
            await weatherLocalDataSource.getLastCurrentWeather(position);
        if (localData == null) {
          return dartz.Left(
            error is WeatherAppException ? error : WeatherAppException(),
          );
        }
        return dartz.Right(localData);
      } catch (cacheError) {
        print(
            "getCurrentWeatherData cacheError: $error , stackTrace: $stackTrace");
        return dartz.Left(WeatherAppException());
      }
    }
  }

  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
    String cityName, {
    bool doSaveToCache = true,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteWeatherData =
            await weatherRemoteDataSource.getCityWeatherData(cityName);
        await weatherLocalDataSource.cacheCityWeather(
          cityName,
          remoteWeatherData,
        );
        return dartz.Right(remoteWeatherData);
      } else {
        throw NetworkException();
      }
    } catch (error, stackTrace) {
      print("getCurrentWeatherData error: $error , stackTrace: $stackTrace");
      try {
        final localData =
            await weatherLocalDataSource.getLastCityWeather(cityName);
        if (localData == null) {
          return dartz.Left(
            error is WeatherAppException ? error : WeatherAppException(),
          );
        }
        return dartz.Right(localData);
      } catch (cacheError) {
        print(
          "getCurrentWeatherData cacheError: $error , stackTrace: $stackTrace",
        );

        return dartz.Left(WeatherAppException());
      }
    }
  }

  @override
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    PositionCoordinates position, {
    bool doSaveToCache = true,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteWeatherData =
            await weatherRemoteDataSource.getWeeklyWeather(position);
        await weatherLocalDataSource.cacheWeeklyWeather(
          position,
          remoteWeatherData,
        );
        return dartz.Right(remoteWeatherData);
      } else {
        throw NetworkException();
      }
    } catch (error, stackTrace) {
      print("getCurrentWeatherData error: $error , stackTrace: $stackTrace");

      try {
        final localData =
            await weatherLocalDataSource.getLastWeeklyWeather(position);
        if (localData == null) {
          return dartz.Left(
            error is WeatherAppException ? error : WeatherAppException(),
          );
        }
        return dartz.Right(localData);
      } catch (cacheError, stackTrace) {
        print(
          "getCurrentWeatherData cacheError: $error , stackTrace: $stackTrace",
        );
        return dartz.Left(WeatherAppException());
      }
    }
  }
}
