part of weather_app;

class WeatherParams extends Equatable {
  final PositionCoordinates coordinates;

  const WeatherParams({required this.coordinates});

  @override
  List<Object?> get props => [coordinates];
}
