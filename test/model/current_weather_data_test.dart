import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather_app.dart';

import '../helper/model_read.dart';

void main() {
  group('CurrentWeatherData.fromJson', () {
    final mockJson = jsonDecode(modelReaderHelper('current_weather_data.json'));

    test('should correctly parse JSON into CurrentWeatherData', () {
      final result = CurrentWeatherData.fromJson(mockJson);

      expect(result, isA<CurrentWeatherData>());

      expect(result.coord.latitude, 19.5895);
      expect(result.coord.longitude, 86.3141);
      expect(result.name, 'Lucknow');
      expect(result.cod, 200);
      expect(result.visibility, 10000);
      expect(result.clouds, 100);
      expect(result.weather.length, 1);
      expect(result.weather[0].main, 'Clouds');
      expect(result.main.temp, 30.35);
      expect(result.wind.speed, 0.21);
      expect(result.sys.country, 'IN');

      final expectedDay = DateFormat("EEEE dd MMMM").format(DateTime.now());
      expect(result.day, expectedDay);

      expect(result.image, isA<IconData>());
    });
  });
}
