import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/weather_app.dart';

import '../../../../helper/model_read.dart';
import 'bloc_test.mocks.dart';

@GenerateMocks([
  GetCurrentWeatherData,
  GetWeeklyWeather,
  GetCityWeather,
  LocationService,
])
void main() {
  late WeatherAppBloc bloc;
  late MockGetCurrentWeatherData mockGetCurrentWeatherData;
  late MockGetWeeklyWeather mockGetWeeklyWeather;
  late MockGetCityWeather mockGetCityWeather;
  late MockLocationService mockLocationService;

  setUp(() {
    mockGetCurrentWeatherData = MockGetCurrentWeatherData();
    mockGetWeeklyWeather = MockGetWeeklyWeather();
    mockGetCityWeather = MockGetCityWeather();
    mockLocationService = MockLocationService();

    bloc = WeatherAppBloc(
      locationService: mockLocationService,
      getCurrentWeather: mockGetCurrentWeatherData,
      getWeeklyWeather: mockGetWeeklyWeather,
      getWeatherByCity: mockGetCityWeather,
    );
  });

  final position = PositionCoordinates(latitude: 12.34, longitude: 56.78);
  final currentWeather = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')));

  final weeklyWeather = WeeklyWeatherData.fromJson(
      jsonDecode(modelReaderHelper('weekly_weather.json')));
  final exception = WeatherAppException(errorMessage: "Error!");

  group('WeatherAppBloc', () {
    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, LocationPermissionState] when CurrentLocationEvent succeeds',
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
      'emits [Loading, WeatherErrorState] when CurrentLocationEvent fails',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Left(exception));
        return bloc;
      },
      act: (bloc) => bloc.add(CurrentLocationEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.location),
        WeatherErrorState(type: WeatherStateType.location, error: exception),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, CurrentWeatherDataLoadedState] when CurrentLocationWeatherEvent succeeds',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetCurrentWeatherData(any))
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
      'emits [Loading, WeatherErrorState] when CurrentLocationWeatherEvent fails',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetCurrentWeatherData(any))
            .thenAnswer((_) async => dartz.Left(exception));
        return bloc;
      },
      act: (bloc) => bloc.add(CurrentLocationWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.currentWeather),
        isA<WeatherErrorState>()
            .having((e) => e.type, 'type', WeatherStateType.currentWeather),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, CityWeatherLoadedState] when CityWeatherEvent succeeds',
      build: () {
        when(mockGetCityWeather(any))
            .thenAnswer((_) async => dartz.Right(currentWeather));
        return bloc;
      },
      act: (bloc) => bloc.add(CityWeatherEvent(cityName: 'London')),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.city),
        CityWeatherLoadedState(
          type: WeatherStateType.city,
          weatherData: currentWeather,
          cityName: 'London',
        ),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, WeatherErrorState] when CityWeatherEvent fails',
      build: () {
        when(mockGetCityWeather(any))
            .thenAnswer((_) async => dartz.Left(exception));
        return bloc;
      },
      act: (bloc) => bloc.add(CityWeatherEvent(cityName: 'Paris')),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.city),
        isA<WeatherErrorState>()
            .having((e) => e.type, 'type', WeatherStateType.city),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, WeeklyForecastLoadedState] when WeeklyForecastWeatherEvent succeeds',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetWeeklyWeather(any))
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
      'emits [Loading, WeatherErrorState] when WeeklyForecastWeatherEvent fails',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => dartz.Right(position));
        when(mockGetWeeklyWeather(any))
            .thenAnswer((_) async => dartz.Left(exception));
        return bloc;
      },
      act: (bloc) => bloc.add(WeeklyForecastWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.forecast),
        isA<WeatherErrorState>()
            .having((e) => e.type, 'type', WeatherStateType.forecast),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, MarkerInfoDataLoadedState] when MarkerInfoWeatherEvent succeeds',
      build: () {
        when(mockGetCurrentWeatherData(any))
            .thenAnswer((_) async => dartz.Right(currentWeather));
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
      'emits [Loading, WeatherErrorState] when MarkerInfoWeatherEvent fails',
      build: () {
        when(mockGetCurrentWeatherData(any))
            .thenAnswer((_) async => dartz.Left(exception));
        return bloc;
      },
      act: (bloc) => bloc.add(MarkerInfoWeatherEvent(coordinates: position)),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.markerInfo),
        isA<WeatherErrorState>()
            .having((e) => e.type, 'type', WeatherStateType.markerInfo),
      ],
    );
  });
}
