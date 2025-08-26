part of weather_app;

/// A model class representing geographical coordinates with latitude and longitude.
class PositionCoordinates {
  final double latitude;
  final double longitude;

  PositionCoordinates({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {'lat': latitude, 'lon': longitude};
  }

  factory PositionCoordinates.fromMap(Map<String, dynamic> map) {
    return PositionCoordinates(
      latitude: (map['lat'] as num).toDouble(),
      longitude: (map['lon'] as num).toDouble(),
    );
  }
}
