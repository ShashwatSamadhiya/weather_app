part of '../../weather_app.dart';

class WeatherData {
  final int id;
  final String main;
  final String description;
  final String icon;

  const WeatherData({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        id: json['id'],
        main: json['main'],
        description: json['description'],
        icon: json['icon'],
      );
}
