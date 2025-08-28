part of weather_app;

class CityWeather extends StatefulWidget {
  final String cityName;
  const CityWeather({
    super.key,
    required this.cityName,
  });

  @override
  State<CityWeather> createState() => _CityWeatherState();
}

class _CityWeatherState extends State<CityWeather> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWheatherData();
    });
    super.initState();
  }

  void getWheatherData() {
    context.read<WeatherAppBloc>().add(
          CityWeatherEvent(cityName: widget.cityName),
        );
  }

  Widget builder() {
    return BlocBuilder<WeatherAppBloc, WeatherState>(
        buildWhen: (previous, current) {
      return current.type == WeatherStateType.city;
    }, builder: (context, state) {
      if (state is WeatherErrorState) {
        return ErrorWidget(
          errorMessage: state.message,
          onRetry: getWheatherData,
        );
      } else if (state is CityWeatherLoadedState) {
        return CurrenWeatherUi(weatherData: state.weatherData);
      }
      return WeatherLoadingScreen(
        loadingMessage: 'fetching weather data for city ${widget.cityName}...',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return builder();
  }
}
