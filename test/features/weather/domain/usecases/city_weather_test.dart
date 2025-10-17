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
  late GetCityWeather usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCityWeather(mockWeatherRepository);
  });

  final routeData = CityWeatherApiRouteData(cityName: 'London');
  final weatherData = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')));
  final exception = WeatherAppException(errorMessage: 'Failed to fetch');

  test('should return Right(CurrentWeatherData) when repository succeeds',
      () async {
    when(mockWeatherRepository.getCityWeatherData(routeData))
        .thenAnswer((_) async => dartz.Right(weatherData));

    final result = await usecase(routeData);

    expect(result, dartz.Right(weatherData));
    verify(mockWeatherRepository.getCityWeatherData(routeData)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });

  test('should return Left(WeatherAppException) when repository fails',
      () async {
    when(mockWeatherRepository.getCityWeatherData(routeData))
        .thenAnswer((_) async => dartz.Left(exception));

    final result = await usecase(routeData);

    expect(result, dartz.Left(exception));
    verify(mockWeatherRepository.getCityWeatherData(routeData)).called(1);
    verifyNoMoreInteractions(mockWeatherRepository);
  });
}
