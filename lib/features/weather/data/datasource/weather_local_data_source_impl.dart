part of weather_app;

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _cachedCityWeatherPrefix = 'CACHED_CITY_WEATHER_';
  static const _cachedCurrentWeatherPrefix = 'CACHED_CURRENT_WEATHER_';
  static const _cachedWeeklyWeatherPrefix = 'CACHED_WEEKLY_WEATHER_';

  static const _lastKnownCurrentWeatherKey = 'LAST_KNOWN_CURRENT_WEATHER';
  static const _lastKnownWeeklyWeatherKey = 'LAST_KNOWN_WEEKLY_WEATHER';

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  String _coordsKey(PositionCoordinates position, String prefix) =>
      '$prefix${position.latitude}_${position.longitude}';

  // --- CURRENT WEATHER ---
  @override
  Future<void> cacheCurrentWeather(
      PositionCoordinates position, CurrentWeatherData weatherData) async {
    final key = _coordsKey(position, _cachedCurrentWeatherPrefix);
    final jsonString = json.encode(weatherData.toJson());
    await sharedPreferences.setString(key, jsonString);
    await sharedPreferences.setString(_lastKnownCurrentWeatherKey, jsonString);
  }

  @override
  Future<CurrentWeatherData?> getLastCurrentWeather(
      PositionCoordinates position) async {
    final key = _coordsKey(position, _cachedCurrentWeatherPrefix);
    final jsonString = sharedPreferences.getString(key);

    if (jsonString != null) {
      return CurrentWeatherData.fromJson(json.decode(jsonString));
    }

    final fallback = sharedPreferences.getString(_lastKnownCurrentWeatherKey);
    if (fallback != null) {
      return CurrentWeatherData.fromJson(json.decode(fallback));
    }
    return null;
  }

  @override
  Future<void> cacheCityWeather(
      String cityName, CurrentWeatherData weatherData) async {
    final jsonString = json.encode(weatherData.toJson());
    await sharedPreferences.setString(
      '$_cachedCityWeatherPrefix$cityName',
      jsonString,
    );
  }

  @override
  Future<CurrentWeatherData?> getLastCityWeather(String cityName) async {
    final jsonString =
        sharedPreferences.getString('$_cachedCityWeatherPrefix$cityName');
    if (jsonString != null) {
      return CurrentWeatherData.fromJson(json.decode(jsonString));
    }

    return null;
  }

  @override
  Future<void> cacheWeeklyWeather(
      PositionCoordinates position, WeeklyWeatherData weatherData) async {
    final key = _coordsKey(position, _cachedWeeklyWeatherPrefix);
    final jsonString = json.encode(weatherData.toJson());
    await sharedPreferences.setString(key, jsonString);
    await sharedPreferences.setString(_lastKnownWeeklyWeatherKey, jsonString);
  }

  @override
  Future<WeeklyWeatherData?> getLastWeeklyWeather(
      PositionCoordinates position) async {
    final key = _coordsKey(position, _cachedWeeklyWeatherPrefix);
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      return WeeklyWeatherData.fromCacheJson(json.decode(jsonString));
    }

    final fallback = sharedPreferences.getString(_lastKnownWeeklyWeatherKey);
    if (fallback != null) {
      return WeeklyWeatherData.fromCacheJson(json.decode(fallback));
    }

    return null;
  }
}
