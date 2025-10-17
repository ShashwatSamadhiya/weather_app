import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'weather_remotesource_test.mocks.dart';

@GenerateMocks([
  ApiClient,
  WeatherAppApiHelper,
  CityWeatherApiRouteData,
  CurrentWeatherApiRouteData,
  WeeklyWeatherApiRouteData
])
void main() {
  late MockApiClient mockApiClient;
  late MockWeatherAppApiHelper mockWeatherAppApiHelper;
  late WeatherRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockWeatherAppApiHelper = MockWeatherAppApiHelper();
    remoteDataSource = WeatherRemoteDataSourceImpl(
      apiClient: mockApiClient,
      weatherAppApiHelper: mockWeatherAppApiHelper,
    );
  });

  group('WeatherRemoteDataSourceImpl', () {
    final currentWeatherData = CurrentWeatherData.fromJson(
        jsonDecode(modelReaderHelper('current_weather_data.json')));

    final weeklyWeatherData = WeeklyWeatherData.fromJson(
        jsonDecode(modelReaderHelper('weekly_weather.json')));

    test('getCurrentWeatherData returns data when successful', () async {
      when(mockWeatherAppApiHelper.ensure<CurrentWeatherData>(
        any,
        parser: anyNamed('parser'),
      )).thenAnswer((_) async => dartz.Right(currentWeatherData));

      final result = await remoteDataSource
          .getCurrentWeatherData(MockCurrentWeatherApiRouteData());

      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception()), currentWeatherData);
      verify(mockWeatherAppApiHelper.ensure<CurrentWeatherData>(
        any,
        parser: anyNamed('parser'),
      )).called(1);
    });

    test('getCityWeatherData returns data when successful', () async {
      final routeData = MockCityWeatherApiRouteData();
      when(mockWeatherAppApiHelper.ensure<CurrentWeatherData>(
        any,
        parser: anyNamed('parser'),
      )).thenAnswer((_) async => dartz.Right(currentWeatherData));

      final result = await remoteDataSource.getCityWeatherData(routeData);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception()), currentWeatherData);
      verify(mockWeatherAppApiHelper.ensure<CurrentWeatherData>(
        any,
        parser: anyNamed('parser'),
      )).called(1);
    });

    test('getWeeklyWeather returns data when successful', () async {
      final routeData = MockWeeklyWeatherApiRouteData();
      when(mockWeatherAppApiHelper.ensure<WeeklyWeatherData>(
        any,
        parser: anyNamed('parser'),
      )).thenAnswer((_) async => dartz.Right(weeklyWeatherData));

      final result = await remoteDataSource.getWeeklyWeather(routeData);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => throw Exception()), weeklyWeatherData);
      verify(mockWeatherAppApiHelper.ensure<WeeklyWeatherData>(
        any,
        parser: anyNamed('parser'),
      )).called(1);
    });

    test('returns Left when WeatherAppApiHelper fails', () async {
      final routeData = MockCurrentWeatherApiRouteData();
      final exception = WeatherAppException(errorMessage: 'Error');

      when(mockWeatherAppApiHelper.ensure<CurrentWeatherData>(
        any,
        parser: anyNamed('parser'),
      )).thenAnswer((_) async => dartz.Left(exception));

      final result = await remoteDataSource.getCurrentWeatherData(routeData);

      expect(result.isLeft(), true);
      result.fold((l) => expect(l, exception), (_) => null);
    });
  });
}
