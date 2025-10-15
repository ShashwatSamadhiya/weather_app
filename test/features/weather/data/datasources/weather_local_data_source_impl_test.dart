import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'weather_local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late WeatherLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = WeatherLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('WeatherLocalDataSourceImpl', () {
    final position = PositionCoordinates(latitude: 12.34, longitude: 56.78);
    final currentWeather = CurrentWeatherData.fromJson(
        jsonDecode(modelReaderHelper('current_weather_data.json')));

    final weeklyWeather = WeeklyWeatherData.fromJson(
        jsonDecode(modelReaderHelper('weekly_weather.json')));

    group('cacheCurrentWeather', () {
      test('should cache current weather data correctly', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        await dataSource.cacheCurrentWeather(position, currentWeather);

        final expectedKey =
            'CACHED_CURRENT_WEATHER_${position.latitude}_${position.longitude}';
        final jsonString = json.encode(currentWeather.toJson());

        verify(mockSharedPreferences.setString(expectedKey, jsonString));
        verify(mockSharedPreferences.setString(
            'LAST_KNOWN_CURRENT_WEATHER', jsonString));
      });
    });

    group('getLastCurrentWeather', () {
      test('should return cached current weather data', () async {
        final key =
            'CACHED_CURRENT_WEATHER_${position.latitude}_${position.longitude}';
        when(mockSharedPreferences.getString(key))
            .thenReturn(json.encode(currentWeather.toJson()));

        final result = await dataSource.getLastCurrentWeather(position);
        expect(result, isA<CurrentWeatherData>());
        expect(result!.name, 'Lucknow');
      });

      test('should return fallback if cache missing', () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        when(mockSharedPreferences.getString('LAST_KNOWN_CURRENT_WEATHER'))
            .thenReturn(json.encode(currentWeather.toJson()));

        final result = await dataSource.getLastCurrentWeather(position);

        expect(result, isA<CurrentWeatherData>());
        expect(result!.name, 'Lucknow');
      });

      test('should return null if both missing', () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final result = await dataSource.getLastCurrentWeather(position);

        expect(result, isNull);
      });
    });

    group('cacheCityWeather', () {
      test('should cache city weather data correctly', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        await dataSource.cacheCityWeather('Mumbai', currentWeather);

        verify(mockSharedPreferences.setString(
          'CACHED_CITY_WEATHER_Mumbai',
          json.encode(currentWeather.toJson()),
        ));
      });

      test('should return cached city weather', () async {
        when(mockSharedPreferences.getString('CACHED_CITY_WEATHER_Mumbai'))
            .thenReturn(json.encode(currentWeather.toJson()));

        final result = await dataSource.getLastCityWeather('Mumbai');

        expect(result, isA<CurrentWeatherData>());
        expect(result!.name, 'Lucknow');
      });

      test('should return null when city not cached', () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final result = await dataSource.getLastCityWeather('Mumbai');

        expect(result, isNull);
      });
    });

    group('cacheWeeklyWeather', () {
      test('should cache weekly weather data', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        await dataSource.cacheWeeklyWeather(position, weeklyWeather);

        final expectedKey =
            'CACHED_WEEKLY_WEATHER_${position.latitude}_${position.longitude}';
        final jsonString = json.encode(weeklyWeather.toJson());

        verify(mockSharedPreferences.setString(expectedKey, jsonString));
        verify(mockSharedPreferences.setString(
            'LAST_KNOWN_WEEKLY_WEATHER', jsonString));
      });

      test('should get cached weekly weather data', () async {
        final key =
            'CACHED_WEEKLY_WEATHER_${position.latitude}_${position.longitude}';
        when(mockSharedPreferences.getString(key))
            .thenReturn(json.encode(weeklyWeather.toJson()));

        final result = await dataSource.getLastWeeklyWeather(position);

        expect(result, isA<WeeklyWeatherData>());
        expect(result!.weekWeatherdata.length, 7);
        expect(result.weekWeatherdata.first.name, 'Thunderstorm');
      });

      test('should fallback if cache not found', () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        when(mockSharedPreferences.getString('LAST_KNOWN_WEEKLY_WEATHER'))
            .thenReturn(json.encode(weeklyWeather.toJson()));

        final result = await dataSource.getLastWeeklyWeather(position);

        expect(result, isA<WeeklyWeatherData>());
        expect(result!.weekWeatherdata.first.name, 'Thunderstorm');
      });

      test('should return null if both cache and fallback missing', () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final result = await dataSource.getLastWeeklyWeather(position);

        expect(result, isNull);
      });
    });
  });
}
