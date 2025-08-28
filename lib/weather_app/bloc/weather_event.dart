part of weather_app;

/// Base class for all weather events.
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

/// event to fetch location
class CurrentLocationEvent extends WeatherEvent {
  const CurrentLocationEvent();
}

class CurrentLocationWeatherEvent extends WeatherEvent {
  const CurrentLocationWeatherEvent();
}

class WeeklyForecastWeatherEvent extends WeatherEvent {
  const WeeklyForecastWeatherEvent();
}

class CityWeatherEvent extends WeatherEvent {
  final String cityName;
  const CityWeatherEvent({required this.cityName});

  @override
  List<Object> get props => [cityName];
}

class MarkerInfoWeatherEvent extends WeatherEvent {
  final PositionCoordinates coordinates;
  const MarkerInfoWeatherEvent({required this.coordinates});

  @override
  List<Object> get props => [coordinates];
}
