import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'weather_repository_impl_test.mocks.dart';

@GenerateMocks([
  WeatherRemoteDataSource,
  WeatherLocalDataSource,
  NetworkInfo,
])
void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockRemote;
  late MockWeatherLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  final position = PositionCoordinates(latitude: 12.34, longitude: 56.78);
  const cityName = 'Lucknow';

  final currentWeather = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')));

  final weeklyWeather = WeeklyWeatherData.fromJson(
      jsonDecode(modelReaderHelper('weekly_weather.json')));
  setUp(() {
    mockRemote = MockWeatherRemoteDataSource();
    mockLocal = MockWeatherLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      weatherRemoteDataSource: mockRemote,
      weatherLocalDataSource: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getCurrentWeatherData', () {
    test('returns remote data and caches when connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getCurrentWeatherData(position))
          .thenAnswer((_) async => currentWeather);

      final result = await repository.getCurrentWeatherData(position);

      expect(result, dartz.Right(currentWeather));
      verify(mockLocal.cacheCurrentWeather(position, currentWeather)).called(1);
    });

    test('returns local cache when remote fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getCurrentWeatherData(position))
          .thenThrow(Exception('API error'));
      when(mockLocal.getLastCurrentWeather(position))
          .thenAnswer((_) async => currentWeather);

      final result = await repository.getCurrentWeatherData(position);

      expect(result, dartz.Right(currentWeather));
      verify(mockLocal.getLastCurrentWeather(position)).called(1);
    });

    test('returns error when both remote and cache fail', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getCurrentWeatherData(position))
          .thenThrow(Exception('API error'));
      when(mockLocal.getLastCurrentWeather(position))
          .thenAnswer((_) async => null);

      final result = await repository.getCurrentWeatherData(position);

      expect(result.isLeft(), true);
      verify(mockLocal.getLastCurrentWeather(position)).called(1);
    });

    test('returns cached data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getLastCurrentWeather(position))
          .thenAnswer((_) async => currentWeather);

      final result = await repository.getCurrentWeatherData(position);

      expect(result, dartz.Right(currentWeather));
    });
  });

  group('getCityWeatherData', () {
    test('returns remote city weather and caches when connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getCityWeatherData(cityName))
          .thenAnswer((_) async => currentWeather);

      final result = await repository.getCityWeatherData(cityName);

      expect(result, dartz.Right(currentWeather));
      verify(mockLocal.cacheCityWeather(cityName, currentWeather)).called(1);
    });

    test('returns cached city weather on remote failure', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getCityWeatherData(cityName))
          .thenThrow(Exception('API error'));
      when(mockLocal.getLastCityWeather(cityName))
          .thenAnswer((_) async => currentWeather);

      final result = await repository.getCityWeatherData(cityName);

      expect(result, dartz.Right(currentWeather));
    });

    test('returns error when both fail', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getCityWeatherData(cityName))
          .thenThrow(Exception('API error'));
      when(mockLocal.getLastCityWeather(cityName))
          .thenAnswer((_) async => null);

      final result = await repository.getCityWeatherData(cityName);

      expect(result.isLeft(), true);
    });
  });

  group('getWeeklyWeather', () {
    test('returns remote weekly weather and caches', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getWeeklyWeather(position))
          .thenAnswer((_) async => weeklyWeather);

      final result = await repository.getWeeklyWeather(position);

      expect(result, dartz.Right(weeklyWeather));
      verify(mockLocal.cacheWeeklyWeather(position, weeklyWeather)).called(1);
    });

    test('returns cached weekly weather on remote failure', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getWeeklyWeather(position))
          .thenThrow(Exception('API error'));
      when(mockLocal.getLastWeeklyWeather(position))
          .thenAnswer((_) async => weeklyWeather);

      final result = await repository.getWeeklyWeather(position);

      expect(result, dartz.Right(weeklyWeather));
      verify(mockLocal.getLastWeeklyWeather(position)).called(1);
    });

    test('returns error when both remote and cache fail', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getWeeklyWeather(position))
          .thenThrow(Exception('API error'));
      when(mockLocal.getLastWeeklyWeather(position))
          .thenAnswer((_) async => null);

      final result = await repository.getWeeklyWeather(position);

      expect(result.isLeft(), true);
    });
  });
}
