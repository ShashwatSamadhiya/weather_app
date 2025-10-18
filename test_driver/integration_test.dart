import 'package:integration_test/integration_test_driver.dart';
import 'dart:io';

///flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart --dart-define=WEATHER_API_ACCESS_KEY=db21f0e6d460f2fccbbb84651e0ee2e2 --dart-define=GOOGLE_MAPS_KEY=AIzaSyCbJC9DBHfHdsmfYyzo2r0LQEIKJQHgcT4

Future<void> main() async {
  await Process.run('adb', [
    'shell',
    'pm',
    'grant',
    'com.example.weather_app',
    'android.permission.ACCESS_FINE_LOCATION'
  ]);

  await integrationDriver();
}
