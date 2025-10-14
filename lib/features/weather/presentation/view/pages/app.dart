import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/weather_app.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  Map<String, Widget Function(BuildContext)> get routes => {
        WeatherHomePage.routeName: (context) => const WeatherHomePage(),
        SearchCityWeather.routeName: (context) => const SearchCityWeather(),
      };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WeatherAppBloc>(),
      child: WeatherAppView(
        routes: routes,
      ),
    );
  }
}
