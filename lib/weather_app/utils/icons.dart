part of '../weather_app.dart';

class WeatherIcons {
  static IconData getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case "thunderstorm":
        return Icons.flash_on; // ⚡
      case "drizzle":
        return Icons.grain; // 🌧️ drizzle drops
      case "rain":
        return Icons.umbrella; // ☔
      case "snow":
        return Icons.ac_unit; // ❄️
      case "clear":
        return Icons.wb_sunny; // ☀️
      case "clouds":
        return Icons.cloud; // ☁️
      default:
        return Icons.help_outline; // fallback
    }
  }
}
