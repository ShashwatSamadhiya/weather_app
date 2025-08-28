part of weather_app;

class WeatherDataByHour {
  final String cod;
  final int message;
  final int cnt;
  // final List<HourlyWeatherData> hourlyWeatherList;
  // final City? city;

  const WeatherDataByHour({
    required this.cod,
    required this.message,
    required this.cnt,
    // required this.hourlyWeatherList,
    // required this.city,
  });
}
