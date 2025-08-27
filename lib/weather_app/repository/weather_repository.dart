part of '../weather_app.dart';

// abstract class WeatherRemoteDataSource {
//   Future<CurrentWeatherModel> getCurrentWeather(LatLong latLong);
//   Future<WeeklyWeatherModel> getWeeklyWeather(LatLong latLong);
//   Future<CurrentWeatherModel> getCityWeather(String query);
// }

class WeatherRepositoryDataSource {
  late http.Client _httpClient;

  WeatherRepositoryDataSource({http.Client? httpClient}) {
    _httpClient = httpClient ?? http.Client();
  }

  /// Base API path for the currency converter service.
  final String _baseApiPath = 'https://api.openweathermap.org/data/2.5';

  final String _weeklyWeatherBaseApiPath =
      'https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';
}
