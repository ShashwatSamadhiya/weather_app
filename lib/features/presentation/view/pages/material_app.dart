part of weather_app;

class WeatherAppView extends StatefulWidget {
  final Map<String, Widget Function(BuildContext)> routes;
  const WeatherAppView({
    super.key,
    required this.routes,
  });

  @override
  State<WeatherAppView> createState() => _WeatherAppViewState();
}

class _WeatherAppViewState extends State<WeatherAppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      navigatorKey: WeatherAppNavigation.instance.navigatorKey,
      theme: WeatherAppTheme.darkTheme,
      routes: widget.routes,
      home: const SplashPage(),
    );
  }
}
