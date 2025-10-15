import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:weather_app/weather_app.dart';

import '../../../helper/model_read.dart';
import 'bloc_test.mocks.dart';

@GenerateMocks([
  GetCurrentWeatherData,
  GetWeeklyWeather,
  GetCityWeather,
  LocationService,
])
void main() {
  late WeatherAppBloc bloc;
  late MockGetCurrentWeatherData mockGetCurrentWeather;
  late MockGetWeeklyWeather mockGetWeeklyWeather;
  late MockGetCityWeather mockGetWeatherByCity;
  late MockLocationService mockLocationService;

  final position = PositionCoordinates(latitude: 12.34, longitude: 56.78);

  final currentWeather = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')));

  final weeklyWeather = WeeklyWeatherData.fromJson(
      jsonDecode(modelReaderHelper('weekly_weather.json')));

  setUp(() {
    mockGetCurrentWeather = MockGetCurrentWeatherData();
    mockGetWeeklyWeather = MockGetWeeklyWeather();
    mockGetWeatherByCity = MockGetCityWeather();
    mockLocationService = MockLocationService();

    bloc = WeatherAppBloc(
      locationService: mockLocationService,
      getCurrentWeather: mockGetCurrentWeather,
      getWeeklyWeather: mockGetWeeklyWeather,
      getWeatherByCity: mockGetWeatherByCity,
    );
  });

  group('CurrentLocationEvent', () {
    blocTest<WeatherAppBloc, WeatherState>(
      'emits LocationPermissionState when location is retrieved successfully',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        return bloc;
      },
      act: (bloc) => bloc.add(CurrentLocationEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.location),
        LocationPermissionState(
          type: WeatherStateType.location,
          coordinates: position,
        ),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits WeatherErrorState when location retrieval fails',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Left(WeatherAppException()));
        return bloc;
      },
      act: (bloc) => bloc.add(CurrentLocationEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.location),
        isA<WeatherErrorState>(),
      ],
    );
  });

  group('CurrentLocationWeatherEvent', () {
    blocTest<WeatherAppBloc, WeatherState>(
      'emits CurrentWeatherDataLoadedState on success',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetCurrentWeather(WeatherParams(coordinates: position)))
            .thenAnswer((_) async => dartz.Right(currentWeather));
        return bloc;
      },
      act: (bloc) => bloc.add(CurrentLocationWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.currentWeather),
        CurrentWeatherDataLoadedState(
          type: WeatherStateType.currentWeather,
          weatherData: currentWeather,
        ),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits WeatherErrorState when repository fails',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetCurrentWeather(WeatherParams(coordinates: position)))
            .thenAnswer((_) async => dartz.Left(WeatherAppException()));
        return bloc;
      },
      act: (bloc) => bloc.add(CurrentLocationWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.currentWeather),
        isA<WeatherErrorState>(),
      ],
    );
  });

  group('CityWeatherEvent', () {
    blocTest<WeatherAppBloc, WeatherState>(
      'emits CityWeatherLoadedState on success',
      build: () {
        when(mockGetWeatherByCity('Mumbai'))
            .thenAnswer((_) async => dartz.Right(currentWeather));
        return bloc;
      },
      act: (bloc) => bloc.add(CityWeatherEvent(cityName: 'Mumbai')),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.city),
        CityWeatherLoadedState(
          type: WeatherStateType.city,
          weatherData: currentWeather,
          cityName: 'Mumbai',
        ),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits WeatherErrorState on repository failure',
      build: () {
        when(mockGetWeatherByCity('Mumbai'))
            .thenAnswer((_) async => dartz.Left(WeatherAppException()));
        return bloc;
      },
      act: (bloc) => bloc.add(CityWeatherEvent(cityName: 'Mumbai')),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.city),
        isA<WeatherErrorState>(),
      ],
    );
  });

  group('WeeklyForecastWeatherEvent', () {
    blocTest<WeatherAppBloc, WeatherState>(
      'emits WeeklyForecastLoadedState on success',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetWeeklyWeather(WeatherParams(coordinates: position)))
            .thenAnswer((_) async => dartz.Right(weeklyWeather));
        return bloc;
      },
      act: (bloc) => bloc.add(WeeklyForecastWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.forecast),
        WeeklyForecastLoadedState(
          type: WeatherStateType.forecast,
          weatherData: weeklyWeather,
        ),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits WeatherErrorState on repository failure',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetWeeklyWeather(WeatherParams(coordinates: position)))
            .thenAnswer((_) async => dartz.Left(WeatherAppException()));
        return bloc;
      },
      act: (bloc) => bloc.add(WeeklyForecastWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.forecast),
        isA<WeatherErrorState>(),
      ],
    );
  });

  group('MarkerInfoWeatherEvent', () {
    blocTest<WeatherAppBloc, WeatherState>(
      'emits MarkerInfoDataLoadedState on success',
      build: () {
        when(mockGetCurrentWeather(WeatherParams(
          coordinates: position,
          doSaveToCache: false,
        ))).thenAnswer((_) async => dartz.Right(currentWeather));
        return bloc;
      },
      act: (bloc) => bloc.add(MarkerInfoWeatherEvent(coordinates: position)),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.markerInfo),
        MarkerInfoDataLoadedState(
          type: WeatherStateType.markerInfo,
          weatherData: currentWeather,
          coordinates: position,
        ),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits WeatherErrorState on repository failure',
      build: () {
        when(mockGetCurrentWeather(WeatherParams(
          coordinates: position,
          doSaveToCache: false,
        ))).thenAnswer((_) async => dartz.Left(WeatherAppException()));
        return bloc;
      },
      act: (bloc) => bloc.add(MarkerInfoWeatherEvent(coordinates: position)),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.markerInfo),
        isA<WeatherErrorState>(),
      ],
    );
  });
}
