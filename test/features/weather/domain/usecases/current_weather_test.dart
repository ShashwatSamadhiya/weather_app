import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'city_weather_test.mocks.dart';

void main() {
  late GetCurrentWeatherData useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetCurrentWeatherData(mockRepository);
  });

  final position = PositionCoordinates(latitude: 12.34, longitude: 56.78);
  final params = WeatherParams(coordinates: position, doSaveToCache: true);

  final currentWeather = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')));
  test('should get current weather from repository', () async {
    // arrange
    when(mockRepository.getCurrentWeatherData(position, doSaveToCache: true))
        .thenAnswer((_) async => dartz.Right(currentWeather));

    // act
    final result = await useCase(params);

    // assert
    expect(result, dartz.Right(currentWeather));
    verify(mockRepository.getCurrentWeatherData(position, doSaveToCache: true))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    final exception = WeatherAppException();

    when(mockRepository.getCurrentWeatherData(position, doSaveToCache: true))
        .thenAnswer((_) async => dartz.Left(exception));

    final result = await useCase(params);

    expect(result, dartz.Left(exception));
    verify(mockRepository.getCurrentWeatherData(position, doSaveToCache: true))
        .called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
