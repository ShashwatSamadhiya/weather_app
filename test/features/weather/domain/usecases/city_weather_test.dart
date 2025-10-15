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
  late GetCityWeather useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetCityWeather(mockRepository);
  });

  final cityName = 'Mumbai';

  final currentWeather = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')));

  test('should get current weather from repository', () async {
    // arrange
    when(mockRepository.getCityWeatherData(cityName))
        .thenAnswer((_) async => dartz.Right(currentWeather));

    final result = await useCase(cityName);

    expect(result, dartz.Right(currentWeather));
    verify(mockRepository.getCityWeatherData(cityName)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    final exception = WeatherAppException();

    when(mockRepository.getCityWeatherData(cityName))
        .thenAnswer((_) async => dartz.Left(exception));

    final result = await useCase(cityName);

    expect(result, dartz.Left(exception));
    verify(mockRepository.getCityWeatherData(cityName)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
