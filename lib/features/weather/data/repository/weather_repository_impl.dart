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
    CurrentWeatherApiRouteData currentWeatherApiRouteData,
  ) async {
    final response = await weatherRemoteDataSource.getCurrentWeatherData(
      currentWeatherApiRouteData,
    );
    return await response.fold(
      (error) async {
        print("getCurrentWeatherData error: $error ,");
        try {
          final localData = await weatherLocalDataSource.getLastCurrentWeather(
            PositionCoordinates(
              latitude: currentWeatherApiRouteData.latitude,
              longitude: currentWeatherApiRouteData.longitude,
            ),
          );
          if (localData == null) {
            return dartz.Left(
              error,
            );
          }
          return dartz.Right(localData);
        } catch (cacheError, stackTrace) {
          log("getCurrentWeatherData cacheError: $cacheError , stackTrace: $stackTrace");
          return dartz.Left(WeatherAppException());
        }
      },
      (data) async {
        if (currentWeatherApiRouteData.doSaveToCache) {
          await weatherLocalDataSource.cacheCurrentWeather(
            PositionCoordinates(
              latitude: currentWeatherApiRouteData.latitude,
              longitude: currentWeatherApiRouteData.longitude,
            ),
            data,
          );
        }
        return dartz.Right(data);
      },
    );
  }

  @override
  Future<dartz.Either<WeatherAppException, CurrentWeatherData>>
      getCityWeatherData(
    CityWeatherApiRouteData cityWeatherApiRouteData,
  ) async {
    final remoteWeatherData = await weatherRemoteDataSource
        .getCityWeatherData(cityWeatherApiRouteData);
    return await remoteWeatherData.fold((error) async {
      log("getCurrentWeatherData error: $error ");
      try {
        final localData = await weatherLocalDataSource
            .getLastCityWeather(cityWeatherApiRouteData.cityName);
        if (localData == null) {
          return dartz.Left(
            error,
          );
        }
        return dartz.Right(localData);
      } catch (cacheError, stackTrace) {
        log(
          "getCurrentWeatherData cacheError: $cacheError , stackTrace: $stackTrace",
        );

        return dartz.Left(WeatherAppException());
      }
    }, (data) async {
      await weatherLocalDataSource.cacheCityWeather(
        cityWeatherApiRouteData.cityName,
        data,
      );
      return dartz.Right(data);
    });
  }

  @override
  Future<dartz.Either<WeatherAppException, WeeklyWeatherData>> getWeeklyWeather(
    WeeklyWeatherApiRouteData weeklyWeatherApiRouteData,
  ) async {
    final remoteWeatherData = await weatherRemoteDataSource
        .getWeeklyWeather(weeklyWeatherApiRouteData);
    return await remoteWeatherData.fold((error) async {
      try {
        final localData = await weatherLocalDataSource
            .getLastWeeklyWeather(weeklyWeatherApiRouteData.position);
        if (localData == null) {
          return dartz.Left(
            error,
          );
        }
        return dartz.Right(localData);
      } catch (cacheError, stackTrace) {
        print(
          "getCurrentWeatherData cacheError: $error , stackTrace: $stackTrace",
        );
        return dartz.Left(WeatherAppException());
      }
    }, (data) async {
      await weatherLocalDataSource.cacheWeeklyWeather(
        PositionCoordinates(
          latitude: weeklyWeatherApiRouteData.position.latitude,
          longitude: weeklyWeatherApiRouteData.position.longitude,
        ),
        data,
      );
      return dartz.Right(data);
    });
  }
}
