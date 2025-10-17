import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/weather_app.dart';
import 'api_client_test.mocks.dart';

// ---- Generate Mocks ----
// This will generate `MockHttpClient` and `MockAPIRouteData`
@GenerateMocks([http.Client, APIRouteData])
void main() {
  late MockClient mockHttpClient;
  late ApiClientImpl apiClient;
  late MockAPIRouteData mockRoute;

  const basePath = 'https://example.com';
  const path = '/weather';
  final queryParams = {'q': 'London'};
  final headers = {'Authorization': 'Bearer token'};
  const body = '{"key": "value"}';
  final fakeResponse = http.Response('OK', 200);

  setUp(() {
    mockHttpClient = MockClient();
    mockRoute = MockAPIRouteData();
    apiClient = ApiClientImpl(httpClient: mockHttpClient);

    // --- Mock default route values ---
    when(mockRoute.baseApiPath).thenReturn(basePath);
    when(mockRoute.path).thenReturn(path);
    when(mockRoute.queryParams).thenReturn(queryParams);
    when(mockRoute.headers).thenReturn(headers);
    when(mockRoute.body).thenReturn(body);
  });

  group('ApiClientImpl', () {
    test('calls GET with correct URI and headers', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => fakeResponse);

      final result = await apiClient.getRequest(mockRoute);

      final expectedUri =
          Uri.parse('$basePath$path').replace(queryParameters: queryParams);

      expect(result.statusCode, 200);
      verify(mockHttpClient.get(expectedUri, headers: headers)).called(1);
    });

    test('calls POST with correct URI, headers and body', () async {
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => fakeResponse);

      final result = await apiClient.postRequest(mockRoute);

      final expectedUri = Uri.parse(path).replace(queryParameters: queryParams);

      expect(result.statusCode, 200);
      verify(mockHttpClient.post(
        expectedUri,
        headers: headers,
        body: body,
      )).called(1);
    });

    test('calls PUT with correct URI, headers and body', () async {
      when(mockHttpClient.put(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => fakeResponse);

      final result = await apiClient.putRequest(mockRoute);

      final expectedUri = Uri.parse(path).replace(queryParameters: queryParams);

      expect(result.statusCode, 200);
      verify(mockHttpClient.put(
        expectedUri,
        headers: headers,
        body: body,
      )).called(1);
    });

    test('calls DELETE with correct URI and headers', () async {
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => fakeResponse);

      final result = await apiClient.deleteRequest(mockRoute);

      final expectedUri = Uri.parse(path).replace(queryParameters: queryParams);

      expect(result.statusCode, 200);
      verify(mockHttpClient.delete(
        expectedUri,
        headers: headers,
      )).called(1);
    });
  });
}
