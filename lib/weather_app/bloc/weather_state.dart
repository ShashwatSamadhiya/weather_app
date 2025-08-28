part of '../weather_app.dart';

enum WeatherStateType { initial, currentWeather, city, forecast, location }

/// Base state for the weather states.
abstract class WeatherState extends Equatable {
  final WeatherStateType type;
  const WeatherState({this.type = WeatherStateType.initial});

  @override
  List<Object> get props => [type];
}

/// State when the weather data is loading
class WeatherLoadingState extends WeatherState {
  const WeatherLoadingState({
    required super.type,
  });
}

/// State when the weather data is empty
class WeatherEmptyState extends WeatherState {
  const WeatherEmptyState() : super(type: WeatherStateType.initial);
}

/// State when the current weather data is loaded
class CurrentWeatherDataLoadedState extends WeatherState {
  final CurrentWeatherData weatherData;
  const CurrentWeatherDataLoadedState({
    required super.type,
    required this.weatherData,
  });

  @override
  List<Object> get props => [type, weatherData];
}

class CityWeatherLoadedState extends WeatherState {
  final String cityName;
  final CurrentWeatherData weatherData;
  const CityWeatherLoadedState({
    required super.type,
    required this.cityName,
    required this.weatherData,
  });

  @override
  List<Object> get props => [cityName, type, weatherData];
}

/// State when the weekly forecast data is loaded
class WeeklyForecastLoadedState extends WeatherState {
  final WeeklyWeatherData weatherData;
  const WeeklyForecastLoadedState({
    required super.type,
    required this.weatherData,
  });

  @override
  List<Object> get props => [type, weatherData];
}

/// State when the error occurs while fetching weather data
class WeatherErrorState extends WeatherState {
  final String message;

  const WeatherErrorState({
    required super.type,
    required this.message,
  });

  @override
  List<Object> get props => [type, message];
}

/// state for location permission and coordinates
class LocationPermissionState extends WeatherState {
  final PositionCoordinates coordinates;
  const LocationPermissionState({
    required super.type,
    required this.coordinates,
  });

  @override
  List<Object> get props => [type, coordinates];
}
