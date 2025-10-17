import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather_app.dart';

import 'weather_app_api_test.mocks.dart';

@GenerateMocks([NetworkInfo])
void main() {
  late MockNetworkInfo mockNetworkInfo;
  late WeatherAppApiHelperImpl apiHelper;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    apiHelper = WeatherAppApiHelperImpl(networkInfo: mockNetworkInfo);
  });

  group('WeatherAppApiHelperImpl.ensure', () {
    test('returns Right when future succeeds on first try', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      Future<http.Response> futureGenerator() async =>
          http.Response('{"temp": 25}', 200);

      final result = await apiHelper.ensure<Map<String, dynamic>>(
        futureGenerator,
        parser: (data) => {'temp': 25},
      );

      expect(result.isRight(), true);
      expect(result.getOrElse(() => {}), {'temp': 25});
      verify(mockNetworkInfo.isConnected).called(1);
    });

    test('retries when NetworkException occurs and succeeds on second attempt',
        () async {
      int callCount = 0;

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      Future<http.Response> futureGenerator() async {
        callCount++;
        if (callCount == 1) {
          throw NetworkException();
        }
        return http.Response('{"temp": 30}', 200);
      }

      final result = await apiHelper.ensure<Map<String, dynamic>>(
        futureGenerator,
        parser: (data) => {'temp': 30},
      );

      expect(result.isRight(), true);
      expect(result.getOrElse(() => {}), {'temp': 30});
      expect(callCount, 2);
    });

    test('returns Left when maxAttempts exceeded due to NetworkException',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      Future<Never> futureGenerator() async {
        throw NetworkException();
      }

      final result = await apiHelper.ensure<Map<String, dynamic>>(
        futureGenerator,
        maxAttempts: 3,
        parser: (data) => {'temp': 0},
      );

      expect(result.isLeft(), true);
      result.fold((l) => expect(l, isA<NetworkException>()), (_) => null);
    });

    test('returns Left for HttpException', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      Future<http.Response> futureGenerator() async =>
          http.Response('Error', 404);

      final result = await apiHelper.ensure<Map<String, dynamic>>(
        futureGenerator,
        parser: (data) => {'temp': 0},
      );

      expect(result.isLeft(), true);
      result.fold((l) => expect(l, isA<HttpException>()), (_) => null);
    });

    test('retries on server errors (500..503) and succeeds', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      int callCount = 0;
      Future<http.Response> futureGenerator() async {
        callCount++;
        if (callCount < 3) {
          return http.Response('Server Error', 500);
        }
        return http.Response('{"temp": 50}', 200);
      }

      final result = await apiHelper.ensure<Map<String, dynamic>>(
        futureGenerator,
        parser: (data) => {'temp': 50},
      );

      expect(result.isRight(), true);
      expect(result.getOrElse(() => {}), {'temp': 50});
      expect(callCount, 3);
    });

    test('throws ParsingException when parser fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      Future<http.Response> futureGenerator() async =>
          http.Response('bad json', 200);

      expect(
        () async => await apiHelper.ensure<Map<String, dynamic>>(
          futureGenerator,
          parser: (data) => throw ParsingException(),
        ),
        returnsNormally,
      );
    });
  });
}
