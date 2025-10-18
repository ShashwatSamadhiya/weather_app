import 'package:integration_test/integration_test_driver.dart';
import 'dart:io';

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
