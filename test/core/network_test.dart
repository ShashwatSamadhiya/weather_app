import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/features/weather_app.dart';

import 'network_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group("Network", () {
    test(
      'check if internet connection is available',
      () async {
        final hasConnection = Future.value(true);

        when(
          mockInternetConnectionChecker.hasConnection,
        ).thenAnswer((_) => hasConnection);

        final result = networkInfoImpl.isConnected;

        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, hasConnection);
      },
    );
  });
}
