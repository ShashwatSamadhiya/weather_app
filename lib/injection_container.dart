part of weather_app;

final getIt = GetIt.instance;

Future<void> initialize() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

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
    () => InternetConnectionChecker.createInstance(
      addresses: [
        AddressCheckOption(
          uri: Uri.parse('https://www.example.com'),
          timeout: Duration(seconds: 2),
        ),
      ],
    ),
  );

  //
  getIt.registerLazySingleton(
    () => http.Client(),
  );

  //
  getIt.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(
      sharedPreferences: getIt(),
    ),
  );

  //
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      weatherRemoteDataSource: getIt(),
      weatherLocalDataSource: getIt(),
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

//

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
