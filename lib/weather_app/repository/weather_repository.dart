part of '../weather_app.dart';

abstract class WeatherRemoteDataSource {
  Future<CurrentWeatherData> getCurrentWeatherData(
    PositionCoordinates position,
  );
  Future<CurrentWeatherData> getCityWeatherData(
    String cityName,
  );
  Future<WeeklyWeatherData> getWeeklyWeather(
    PositionCoordinates position,
  );
}

class WeatherRepositoryDataSourceImpl implements WeatherRemoteDataSource {
  late http.Client _httpClient;

  WeatherRepositoryDataSourceImpl({http.Client? httpClient}) {
    _httpClient = httpClient ?? http.Client();
  }

  static const _apiAccessKey = String.fromEnvironment('WEATHER_API_ACCESS_KEY');

  /// Base API path for the currency converter service.
  final String _baseApiPath = 'https://api.openweathermap.org/data/2.5';

  final String _weeklyWeatherBaseApiPath =
      'https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

  @override
  Future<CurrentWeatherData> getCurrentWeatherData(
    PositionCoordinates position,
  ) async {
    final response = await _httpClient.get(
      Uri.parse(
        "$_baseApiPath/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$_apiAccessKey",
      ),
      headers: {
        'content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return CurrentWeatherData.fromJson(
        json.decode(response.body),
      );
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CurrentWeatherData> getCityWeatherData(String cityName) async {
    var response = await _httpClient.get(Uri.parse(
      '$_baseApiPath/weather?q=$cityName&units=metric&appid=$_apiAccessKey',
    ));

    if (response.statusCode == 200) {
      return CurrentWeatherData.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<WeeklyWeatherData> getWeeklyWeather(
    PositionCoordinates position,
  ) async {
    final response = await _httpClient.get(
      Uri.parse(
        '$_weeklyWeatherBaseApiPath&latitude=${position.latitude}&longitude=${position.longitude}',
      ),
      headers: {
        'content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return WeeklyWeatherData.fromJson(
        json.decode(response.body),
      );
    } else {
      throw ServerException();
    }
  }
}
