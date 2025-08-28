part of weather_app;

/// A model class representing the main weather data.
class WeatherDataModel {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

  const WeatherDataModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) =>
      WeatherDataModel(
        temp: (json['temp'] as num).toDouble(),
        feelsLike: (json['feels_like'] as num).toDouble(),
        tempMin: (json['temp_min'] as num).toDouble(),
        tempMax: (json['temp_max'] as num).toDouble(),
        pressure: json['pressure'],
        humidity: json['humidity'],
        seaLevel: json['sea_level'],
        grndLevel: json['grnd_level'],
      );
}
