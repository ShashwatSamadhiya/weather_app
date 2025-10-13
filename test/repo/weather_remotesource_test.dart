import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/features/weather_app.dart';

import '../helper/model_read.dart';
import 'weather_remotesource_test.mocks.dart';

@GenerateMocks([http.Client, NetworkInfo])
void main() {
  late WeatherRepositoryDataSourceImpl dataSource;
  late MockClient mockHttpClient;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockHttpClient = MockClient();
    mockNetworkInfo = MockNetworkInfo();
    dataSource = WeatherRepositoryDataSourceImpl(
      httpClient: mockHttpClient,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getCurrentWeatherData', () {
    final position = PositionCoordinates(latitude: 10.0, longitude: 20.0);
    final tJsonResponse = modelReaderHelper('current_weather_data.json');
    // mock json body

    test('should throw NetworkException when no internet', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final call = dataSource.getCurrentWeatherData;

      expect(() => call(position), throwsA(isA<NetworkException>()));
    });

    test('should return CurrentWeatherData when response code is 200',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(tJsonResponse, 200),
      );

      final result = await dataSource.getCurrentWeatherData(position);

      expect(result, isA<CurrentWeatherData>());
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      expect(
        () => dataSource.getCurrentWeatherData(position),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getCityWeatherData', () {
    const cityName = 'London';
    final tJsonResponse = modelReaderHelper('current_weather_data.json');

    test('should return CurrentWeatherData on success', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(tJsonResponse, 200),
      );

      final result = await dataSource.getCityWeatherData(cityName);

      expect(result, isA<CurrentWeatherData>());
    });
  });

  group('getWeeklyWeather', () {
    final position = PositionCoordinates(latitude: 12.0, longitude: 77.0);
    final tJsonResponse = modelReaderHelper('weekly_weather.json');

    test('should return WeeklyWeatherData on success', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(tJsonResponse, 200),
      );

      final result = await dataSource.getWeeklyWeather(position);

      expect(result, isA<WeeklyWeatherData>());
    });
  });
}
