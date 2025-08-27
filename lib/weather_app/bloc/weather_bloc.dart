part of '../weather_app.dart';

class WeatherAppBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRemoteDataSource weatherRepository;
  final LocationService locationService;

  WeatherAppBloc({
    required this.weatherRepository,
    required this.locationService,
  }) : super(const WeatherEmptyState()) {
    on<CurrentLocationEvent>(_onCurrentLocationEvent);
    on<CurrentLocationWeatherEvent>(_onCurrentLocationWeatherEvent);
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
}
