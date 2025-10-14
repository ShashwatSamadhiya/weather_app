part of weather_app;

final getIt = GetIt.instance;

Future<void> initialize() async {
  //
  getIt.registerLazySingleton<WeatherAppNavigation>(
    () => WeatherAppNavigation(),
  );

  //
  getIt.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(),
  );

  //
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  //
  getIt.registerLazySingleton(
    () => InternetConnectionChecker.instance,
  );

  //
  getIt.registerLazySingleton(
    () => http.Client(),
  );

  //
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      weatherRemoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  //
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      httpClient: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetCurrentWeatherData(getIt()));
  getIt.registerLazySingleton(() => GetWeeklyWeather(getIt()));
  getIt.registerLazySingleton(() => GetCityWeather(getIt()));

  getIt.registerLazySingleton<MapLayerRemote>(
    () => MapLayerRemoteImpl(networkInfo: getIt()),
  );
  // Repository
  getIt.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remote: getIt(), networkInfo: getIt()),
  );

  //
  getIt.registerFactory(() {
    return WeatherAppBloc(
      locationService: getIt(),
      getCurrentWeather: getIt(),
      getWeatherByCity: getIt(),
      getWeeklyWeather: getIt(),
    );
  });
}
