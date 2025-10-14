import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/weather_app.dart';

import 'bloc_test.mocks.dart';
import '../helper/model_read.dart';

@GenerateMocks([WeatherRemoteDataSource, LocationService])
void main() {
  late MockWeatherRemoteDataSource mockWeatherRepository;
  late MockLocationService mockLocationService;
  late WeatherAppBloc bloc;

  setUp(() {
    mockWeatherRepository = MockWeatherRemoteDataSource();
    mockLocationService = MockLocationService();
    bloc = WeatherAppBloc(
      weatherRepository: mockWeatherRepository,
      locationService: mockLocationService,
    );
  });

  tearDown(() => bloc.close());

  final position = PositionCoordinates(latitude: 10.0, longitude: 20.0);

  group('CurrentLocationEvent', () {
    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, LocationPermissionState] when location is fetched',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => position);
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
      'emits [Loading, Error] when location fails',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenThrow(LocationPermissionException());
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
    final weatherData = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')),
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, CurrentWeatherDataLoadedState]',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => position);
        when(mockWeatherRepository.getCurrentWeatherData(position))
            .thenAnswer((_) async => weatherData);
        return bloc;
      },
      act: (bloc) => bloc.add(CurrentLocationWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.currentWeather),
        CurrentWeatherDataLoadedState(
          type: WeatherStateType.currentWeather,
          weatherData: weatherData,
        ),
      ],
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => position);
        when(mockWeatherRepository.getCurrentWeatherData(position))
            .thenThrow(ServerException());
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
    const city = 'London';
    final weatherData = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')),
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, CityWeatherLoadedState]',
      build: () {
        when(mockWeatherRepository.getCityWeatherData(city))
            .thenAnswer((_) async => weatherData);
        return bloc;
      },
      act: (bloc) => bloc.add(CityWeatherEvent(cityName: city)),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.city),
        CityWeatherLoadedState(
          type: WeatherStateType.city,
          cityName: city,
          weatherData: weatherData,
        ),
      ],
    );
  });

  group('WeeklyForecastWeatherEvent', () {
    final weeklyData = WeeklyWeatherData.fromJson(
      jsonDecode(modelReaderHelper('weekly_weather.json')),
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, WeeklyForecastLoadedState]',
      build: () {
        when(mockLocationService.getCurrentLocation())
            .thenAnswer((_) async => position);
        when(mockWeatherRepository.getWeeklyWeather(position))
            .thenAnswer((_) async => weeklyData);
        return bloc;
      },
      act: (bloc) => bloc.add(WeeklyForecastWeatherEvent()),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.forecast),
        WeeklyForecastLoadedState(
          type: WeatherStateType.forecast,
          weatherData: weeklyData,
        ),
      ],
    );
  });

  group('MarkerInfoWeatherEvent', () {
    final weatherData = CurrentWeatherData.fromJson(
      jsonDecode(modelReaderHelper('current_weather_data.json')),
    );

    blocTest<WeatherAppBloc, WeatherState>(
      'emits [Loading, MarkerInfoDataLoadedState]',
      build: () {
        when(mockWeatherRepository.getCurrentWeatherData(position))
            .thenAnswer((_) async => weatherData);
        return bloc;
      },
      act: (bloc) => bloc.add(MarkerInfoWeatherEvent(coordinates: position)),
      expect: () => [
        const WeatherLoadingState(type: WeatherStateType.markerInfo),
        MarkerInfoDataLoadedState(
          type: WeatherStateType.markerInfo,
          weatherData: weatherData,
          coordinates: position,
        ),
      ],
    );
  });
}
