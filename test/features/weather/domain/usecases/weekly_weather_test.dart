import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'city_weather_test.mocks.dart';

void main() {
  late GetWeeklyWeather useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeeklyWeather(mockRepository);
  });

  final position = PositionCoordinates(latitude: 12.34, longitude: 56.78);
  final params = WeatherParams(coordinates: position, doSaveToCache: true);

  final weeklyWeather = WeeklyWeatherData.fromJson(
      jsonDecode(modelReaderHelper('weekly_weather.json')));

  test('should get weekly weather from repository', () async {
    // arrange
    when(mockRepository.getWeeklyWeather(position))
        .thenAnswer((_) async => dartz.Right(weeklyWeather));

    // act
    final result = await useCase(params);

    // assert
    expect(result, dartz.Right(weeklyWeather));
    verify(mockRepository.getWeeklyWeather(position)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    final exception = WeatherAppException();

    when(mockRepository.getWeeklyWeather(position))
        .thenAnswer((_) async => dartz.Left(exception));

    final result = await useCase(params);

    expect(result, dartz.Left(exception));
    verify(mockRepository.getWeeklyWeather(position)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
