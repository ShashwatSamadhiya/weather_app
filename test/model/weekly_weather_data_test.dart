import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather_app.dart';

import '../helper/model_read.dart';

void main() {
  group('WeeklyWeatherData.fromJson', () {
    final mockJson = jsonDecode(modelReaderHelper('weekly_weather.json'));

    test('should correctly parse JSON into WeeklyWeatherData', () {
      final result = WeeklyWeatherData.fromJson(mockJson);

      expect(result, isA<WeeklyWeatherData>());
      expect(result.weekWeatherdata.length, 7);

      for (int i = 0; i < 7; i++) {
        final dayData = result.weekWeatherdata[i];
        final expectedDate = DateTime.parse(mockJson['daily']['time'][i]);
        final expectedDay =
            DateFormat('EEEE').format(expectedDate).substring(0, 3);

        expect(dayData.day, expectedDay);

        expect(dayData.max, mockJson['daily']['temperature_2m_max'][i]);
        expect(dayData.min, mockJson['daily']['temperature_2m_min'][i]);

        final code = mockJson['daily']['weather_code'][i];
        String expectedName;
        if (code == 0) {
          expectedName = "Clear";
        } else if ((code >= 1 && code <= 3) || (code >= 45 && code <= 48)) {
          expectedName = "Clouds";
        } else if (code >= 51 && code <= 57) {
          expectedName = "Drizzle";
        } else if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) {
          expectedName = "Rain";
        } else if (code >= 71 && code <= 77) {
          expectedName = "Snow";
        } else if (code >= 95 && code <= 99) {
          expectedName = "Thunderstorm";
        } else {
          expectedName = "Clear";
        }
        expect(dayData.name, expectedName);

        expect(dayData.image, isA<IconData>());
      }
    });
  });
}
