import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'city_weather_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() {
  late GetWeeklyWeather usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetWeeklyWeather(mockWeatherRepository);
  });

  final params = WeeklyWeatherApiRouteData(
      position: PositionCoordinates(latitude: 12.3, longitude: 45.6));

  final weeklyData = WeeklyWeatherData.fromJson(
      jsonDecode(modelReaderHelper('weekly_weather.json')));

  final exception = WeatherAppException(errorMessage: 'Failed');

  test('should return Right(WeeklyWeatherData) when repository succeeds',
      () async {
    when(mockWeatherRepository.getWeeklyWeather(params))
        .thenAnswer((_) async => dartz.Right(weeklyData));

    final result = await usecase(params);

    expect(result, dartz.Right(weeklyData));
    verify(mockWeatherRepository.getWeeklyWeather(params)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });

  test('should return Left(WeatherAppException) when repository fails',
      () async {
    when(mockWeatherRepository.getWeeklyWeather(params))
        .thenAnswer((_) async => dartz.Left(exception));

    final result = await usecase(params);

    expect(result, dartz.Left(exception));
    verify(mockWeatherRepository.getWeeklyWeather(params)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
