part of weather_app;

class DayWeatherData {
  final String day;
  final IconData image;
  final double max;
  final double min;
  final String name;

  const DayWeatherData({
    required this.name,
    required this.day,
    required this.image,
    required this.max,
    required this.min,
  });
}
