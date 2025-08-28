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
    on<MarkerInfoWeatherEvent>(_onMarkerInfoEvent);
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
        error: e is WeatherAppException
            ? e
            : WeatherAppException(
                errorMessage: 'Failed to get location: ${e.toString()}',
              ),
      ));
    }
  }

  WeatherAppException getWeatherAppExceptionFromError(
    Object error, {
    String? defaultMessage,
  }) {
    if (error is WeatherAppException) {
      return error;
    } else {
      return WeatherAppException(
        errorMessage: defaultMessage ??
            'An unexpected error occurred: ${error.toString()}',
      );
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
        error: getWeatherAppExceptionFromError(
          error,
          defaultMessage: 'Failed to get weather data: ${error.toString()}',
        ),
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
        error: getWeatherAppExceptionFromError(
          error,
          defaultMessage:
              'Failed to get ${event.cityName} weather data: ${error.toString()}',
        ),
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
        error: getWeatherAppExceptionFromError(
          error,
          defaultMessage:
              'Failed to get weekly forecast data: ${error.toString()}',
        ),
      ));
    }
  }

  Future<void> _onMarkerInfoEvent(
    MarkerInfoWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(const WeatherLoadingState(type: WeatherStateType.markerInfo));
      final weatherData =
          await weatherRepository.getCurrentWeatherData(event.coordinates);
      emit(MarkerInfoDataLoadedState(
        type: WeatherStateType.markerInfo,
        weatherData: weatherData,
        coordinates: event.coordinates,
      ));
    } catch (error) {
      emit(WeatherErrorState(
        type: WeatherStateType.markerInfo,
        error: getWeatherAppExceptionFromError(
          error,
          defaultMessage:
              'Failed to get marker info weather data: ${error.toString()}',
        ),
      ));
    }
  }
}
