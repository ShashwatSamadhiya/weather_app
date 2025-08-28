part of weather_app;

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWheatherData();
    });
    super.initState();
  }

  void getWheatherData() {
    context.read<WeatherAppBloc>().add(CurrentLocationWeatherEvent());
  }

  Widget builder() {
    return BlocBuilder<WeatherAppBloc, WeatherState>(
        buildWhen: (previous, current) {
      return current.type == WeatherStateType.currentWeather;
    }, builder: (context, state) {
      if (state is WeatherErrorState) {
        return ErrorWidget(
          errorMessage: state.message,
          onRetry: getWheatherData,
        );
      } else if (state is CurrentWeatherDataLoadedState) {
        return CurrenWeatherUi(weatherData: state.weatherData);
      }
      return WeatherLoadingScreen(
        loadingMessage: 'fetching weather data...',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return builder();
  }
}
