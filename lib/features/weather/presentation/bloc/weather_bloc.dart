part of weather_app;

class WeatherAppBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherData getCurrentWeather;
  final GetWeeklyWeather getWeeklyWeather;
  final GetCityWeather getWeatherByCity;
  final LocationService locationService;

  WeatherAppBloc({
    required this.locationService,
    required this.getCurrentWeather,
    required this.getWeeklyWeather,
    required this.getWeatherByCity,
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
    final position = await locationService.getCurrentLocation();
    position.fold((error) {
      emit(WeatherErrorState(
        type: WeatherStateType.location,
        error: error,
      ));
    }, (position) {
      emit(LocationPermissionState(
        type: WeatherStateType.location,
        coordinates: position,
      ));
    });
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
    emit(const WeatherLoadingState(type: WeatherStateType.currentWeather));
    final position = await locationService.getCurrentLocation();
    await position.fold((error) {
      emit(WeatherErrorState(
        type: WeatherStateType.location,
        error: error,
      ));
    }, (position) async {
      final fetchWeatherData =
          await getCurrentWeather(CurrentWeatherApiRouteData(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
      fetchWeatherData.fold((error) {
        emit(WeatherErrorState(
          type: WeatherStateType.currentWeather,
          error: getWeatherAppExceptionFromError(
            error,
            defaultMessage: 'Failed to get weather data: ${error.toString()}',
          ),
        ));
      }, (weatherData) {
        emit(CurrentWeatherDataLoadedState(
          type: WeatherStateType.currentWeather,
          weatherData: weatherData,
        ));
      });
    });
  }

  Future<void> _onCityWeatherEvent(
    CityWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoadingState(type: WeatherStateType.city));
    final fetchCityWeatherName = await getWeatherByCity(
      CityWeatherApiRouteData(
        cityName: event.cityName,
      ),
    );
    fetchCityWeatherName.fold((error) {
      emit(WeatherErrorState(
        type: WeatherStateType.city,
        error: getWeatherAppExceptionFromError(
          error,
          defaultMessage:
              'Failed to get ${event.cityName} weather data: ${error.toString()}',
        ),
      ));
    }, (weatherData) {
      emit(CityWeatherLoadedState(
        type: WeatherStateType.city,
        weatherData: weatherData,
        cityName: event.cityName,
      ));
    });
  }

  Future<void> _onWeeklyForecastEvent(
    WeeklyForecastWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoadingState(type: WeatherStateType.forecast));
    final position = await locationService.getCurrentLocation();
    await position.fold((error) {
      emit(WeatherErrorState(
        type: WeatherStateType.location,
        error: error,
      ));
    }, (position) async {
      final fetchWeeklyWeatherData =
          await getWeeklyWeather(WeeklyWeatherApiRouteData(
        position: position,
      ));
      fetchWeeklyWeatherData.fold((error) {
        emit(WeatherErrorState(
          type: WeatherStateType.forecast,
          error: getWeatherAppExceptionFromError(
            error,
            defaultMessage:
                'Failed to get weekly forecast data: ${error.toString()}',
          ),
        ));
      }, (weatherData) {
        emit(WeeklyForecastLoadedState(
          type: WeatherStateType.forecast,
          weatherData: weatherData,
        ));
      });
    });
  }

  Future<void> _onMarkerInfoEvent(
    MarkerInfoWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoadingState(type: WeatherStateType.markerInfo));
    final fetchWeatherData = await getCurrentWeather(
      CurrentWeatherApiRouteData(
        latitude: event.coordinates.latitude,
        longitude: event.coordinates.longitude,
        doSaveToCache: false,
      ),
    );
    fetchWeatherData.fold((error) {
      emit(WeatherErrorState(
        type: WeatherStateType.markerInfo,
        error: getWeatherAppExceptionFromError(
          error,
          defaultMessage:
              'Failed to get marker info weather data: ${error.toString()}',
        ),
      ));
    }, (weatherData) {
      emit(MarkerInfoDataLoadedState(
        type: WeatherStateType.markerInfo,
        weatherData: weatherData,
        coordinates: event.coordinates,
      ));
    });
  }
}
