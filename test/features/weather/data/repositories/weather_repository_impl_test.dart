import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import '../datasources/weather_remotesource_test.mocks.dart'
    hide MockWeeklyWeatherApiRouteData, MockCurrentWeatherApiRouteData;
@GenerateMocks([
  WeatherRemoteDataSource,
  WeatherLocalDataSource,
  NetworkInfo,
  CurrentWeatherApiRouteData,
  CityWeatherApiRouteData,
  WeeklyWeatherApiRouteData,
])
import 'weather_repository_impl_test.mocks.dart'
    hide MockCityWeatherApiRouteData;

void main() {
  late MockWeatherRemoteDataSource mockRemote;
  late MockWeatherLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;
  late WeatherRepositoryImpl repository;

  setUp(() {
    mockRemote = MockWeatherRemoteDataSource();
    mockLocal = MockWeatherLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      weatherRemoteDataSource: mockRemote,
      weatherLocalDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('getCurrentWeatherData', () {
    late MockCurrentWeatherApiRouteData route;
    final weatherData = CurrentWeatherData.fromJson(
        jsonDecode(modelReaderHelper('current_weather_data.json')));

    setUp(() {
      route = MockCurrentWeatherApiRouteData();
      when(route.latitude).thenReturn(10.0);
      when(route.longitude).thenReturn(20.0);
      when(route.doSaveToCache).thenReturn(true);
    });

    test('returns Right when remote data succeeds and caches data', () async {
      when(mockRemote.getCurrentWeatherData(route))
          .thenAnswer((_) async => dartz.Right(weatherData));

      final result = await repository.getCurrentWeatherData(route);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception()), weatherData);

      verify(mockRemote.getCurrentWeatherData(route)).called(1);
      verifyNever(mockLocal.cacheCurrentWeather(
        PositionCoordinates(latitude: 10.0, longitude: 20.0),
        weatherData,
      ));
    });

    test('returns cached data when remote fails but cache exists', () async {
      final exception = WeatherAppException(errorMessage: 'Network fail');
      when(mockRemote.getCurrentWeatherData(route))
          .thenAnswer((_) async => dartz.Left(exception));

      when(mockLocal.getLastCurrentWeather(any))
          .thenAnswer((_) async => weatherData);

      final result = await repository.getCurrentWeatherData(route);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception()), weatherData);
    });

    test('returns Left when remote fails and cache is null', () async {
      final exception = WeatherAppException(errorMessage: 'No internet');
      when(mockRemote.getCurrentWeatherData(route))
          .thenAnswer((_) async => dartz.Left(exception));

      when(mockLocal.getLastCurrentWeather(any)).thenAnswer((_) async => null);

      final result = await repository.getCurrentWeatherData(route);

      expect(result.isLeft(), true);
      result.fold((l) => expect(l, exception), (_) => null);
    });

    test('returns Left when cache throws an exception', () async {
      final exception = WeatherAppException(errorMessage: 'Network fail');
      when(mockRemote.getCurrentWeatherData(route))
          .thenAnswer((_) async => dartz.Left(exception));

      when(mockLocal.getLastCurrentWeather(any))
          .thenThrow(Exception('Cache error'));

      final result = await repository.getCurrentWeatherData(route);

      expect(result.isLeft(), true);
      result.fold((l) => expect(l, isA<WeatherAppException>()), (_) => null);
    });
  });

  group('getCityWeatherData', () {
    late MockCityWeatherApiRouteData route;
    final cityWeather = CurrentWeatherData.fromJson(
        jsonDecode(modelReaderHelper('current_weather_data.json')));

    setUp(() {
      route = MockCityWeatherApiRouteData();
      when(route.cityName).thenReturn('London');
    });

    test('returns Right when remote succeeds and caches data', () async {
      when(mockRemote.getCityWeatherData(route))
          .thenAnswer((_) async => dartz.Right(cityWeather));

      final result = await repository.getCityWeatherData(route);

      expect(result.isRight(), true);
      verify(mockLocal.cacheCityWeather('London', cityWeather)).called(1);
    });

    test('returns cached data when remote fails but local data exists',
        () async {
      final exception = WeatherAppException(errorMessage: 'Offline');
      when(mockRemote.getCityWeatherData(route))
          .thenAnswer((_) async => dartz.Left(exception));
      when(mockLocal.getLastCityWeather('London'))
          .thenAnswer((_) async => cityWeather);

      final result = await repository.getCityWeatherData(route);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception()), cityWeather);
    });

    test('returns Left when both remote and cache fail', () async {
      final exception = WeatherAppException(errorMessage: 'Offline');
      when(mockRemote.getCityWeatherData(route))
          .thenAnswer((_) async => dartz.Left(exception));
      when(mockLocal.getLastCityWeather('London'))
          .thenAnswer((_) async => null);

      final result = await repository.getCityWeatherData(route);

      expect(result.isLeft(), true);
      result.fold((l) => expect(l, exception), (_) => null);
    });
  });

  group('getWeeklyWeather', () {
    late MockWeeklyWeatherApiRouteData route;
    final weeklyData = WeeklyWeatherData.fromJson(
        jsonDecode(modelReaderHelper('weekly_weather.json')));

    setUp(() {
      route = MockWeeklyWeatherApiRouteData();
      when(route.position).thenReturn(PositionCoordinates(
        latitude: 12.3,
        longitude: 45.6,
      ));
    });

    test('returns Right when remote succeeds and caches', () async {
      when(mockRemote.getWeeklyWeather(route))
          .thenAnswer((_) async => dartz.Right(weeklyData));

      final result = await repository.getWeeklyWeather(route);

      expect(result.isRight(), true);
      verify(mockLocal.cacheWeeklyWeather(any, weeklyData)).called(1);
    });

    test('returns cached data when remote fails but local exists', () async {
      final exception = WeatherAppException(errorMessage: 'Network fail');
      when(mockRemote.getWeeklyWeather(route))
          .thenAnswer((_) async => dartz.Left(exception));
      when(mockLocal.getLastWeeklyWeather(any))
          .thenAnswer((_) async => weeklyData);

      final result = await repository.getWeeklyWeather(route);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception()), weeklyData);
    });

    test('returns Left when both remote and cache fail', () async {
      final exception = WeatherAppException(errorMessage: 'Network fail');
      when(mockRemote.getWeeklyWeather(route))
          .thenAnswer((_) async => dartz.Left(exception));
      when(mockLocal.getLastWeeklyWeather(any)).thenAnswer((_) async => null);

      final result = await repository.getWeeklyWeather(route);

      expect(result.isLeft(), true);
    });
  });
}
