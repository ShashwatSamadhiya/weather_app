import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/view/pages/app.dart';
import 'package:weather_app/weather_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const WeatherApp());
}
