part of weather_app;

class WeatherParams extends Equatable {
  final PositionCoordinates coordinates;
  final bool doSaveToCache;

  const WeatherParams({required this.coordinates, this.doSaveToCache = true});

  @override
  List<Object?> get props => [coordinates, doSaveToCache];
}
