part of weather_app;

class WeatherIcons {
  static IconData getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case "thunderstorm":
        return Icons.flash_on;
      case "drizzle":
        return Icons.grain;
      case "rain":
        return Icons.umbrella;
      case "snow":
        return Icons.ac_unit;
      case "clear":
        return Icons.wb_sunny;
      case "clouds":
        return Icons.cloud;
      default:
        return Icons.help_outline; // fallback
    }
  }

  static String getWeatherString(IconData icon) {
    if (icon == Icons.flash_on) return "thunderstorm";
    if (icon == Icons.grain) return "drizzle";
    if (icon == Icons.umbrella) return "rain";
    if (icon == Icons.ac_unit) return "snow";
    if (icon == Icons.wb_sunny) return "clear";
    if (icon == Icons.cloud) return "clouds";
    return "unknown"; // fallback
  }
}
