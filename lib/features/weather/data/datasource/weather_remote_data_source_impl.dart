part of weather_app;

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  late http.Client _httpClient;
  late NetworkInfo networkInfo;

  WeatherRemoteDataSourceImpl({
    http.Client? httpClient,
    required this.networkInfo,
  }) {
    _httpClient = httpClient ?? http.Client();
  }

  Future<void> checkInternetConnection() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException();
    }
  }

  @override
  Future<CurrentWeatherData> getCurrentWeatherData(
    PositionCoordinates position,
  ) async {
    await checkInternetConnection();
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
    await checkInternetConnection();
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
    await checkInternetConnection();
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
