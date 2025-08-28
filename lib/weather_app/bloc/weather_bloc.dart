part of weather_app;

class WeatherAppBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRemoteDataSource weatherRepository;
  final LocationService locationService;

  WeatherAppBloc({
    required this.weatherRepository,
    required this.locationService,
  }) : super(const WeatherEmptyState()) {
    on<CurrentLocationEvent>(_onCurrentLocationEvent);
    on<CurrentLocationWeatherEvent>(_onCurrentLocationWeatherEvent);
    on<WeeklyForecastWeatherEvent>(_onWeeklyForecastEvent);
    on<CityWeatherEvent>(_onCityWeatherEvent);
  }

  Future<void> _onCurrentLocationEvent(
    CurrentLocationEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoadingState(type: WeatherStateType.location));
    try {
      final position = await locationService.getCurrentLocation();
      emit(LocationPermissionState(
        type: WeatherStateType.location,
        coordinates: position,
      ));
    } catch (e) {
      emit(WeatherErrorState(
        type: WeatherStateType.location,
        message: e.toString(),
      ));
    }
  }

  Future<void> _onCurrentLocationWeatherEvent(
    CurrentLocationWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(const WeatherLoadingState(type: WeatherStateType.currentWeather));
      final position = await locationService.getCurrentLocation();
      final weatherData =
          await weatherRepository.getCurrentWeatherData(position);

      emit(CurrentWeatherDataLoadedState(
        type: WeatherStateType.currentWeather,
        weatherData: weatherData,
      ));
    } catch (error) {
      emit(WeatherErrorState(
        type: WeatherStateType.currentWeather,
        message: error.toString(),
      ));
    }
  }

  Future<void> _onCityWeatherEvent(
    CityWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(const WeatherLoadingState(type: WeatherStateType.city));

      final weatherData =
          await weatherRepository.getCityWeatherData(event.cityName);

      emit(CityWeatherLoadedState(
        type: WeatherStateType.city,
        weatherData: weatherData,
        cityName: event.cityName,
      ));
    } catch (error) {
      emit(WeatherErrorState(
        type: WeatherStateType.city,
        message: error.toString(),
      ));
    }
  }

  Future<void> _onWeeklyForecastEvent(
    WeeklyForecastWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(const WeatherLoadingState(type: WeatherStateType.forecast));
      final position = await locationService.getCurrentLocation();
      final weatherData = await weatherRepository.getWeeklyWeather(position);

      emit(WeeklyForecastLoadedState(
        type: WeatherStateType.forecast,
        weatherData: weatherData,
      ));
    } catch (error) {
      emit(WeatherErrorState(
        type: WeatherStateType.forecast,
        message: error.toString(),
      ));
    }
  }
}
