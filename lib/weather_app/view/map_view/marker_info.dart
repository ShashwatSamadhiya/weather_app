part of weather_app;

class MarkerInfo extends StatefulWidget {
  final PositionCoordinates coordinates;
  const MarkerInfo({super.key, required this.coordinates});

  @override
  State<MarkerInfo> createState() => _MarkerInfoState();
}

class _MarkerInfoState extends State<MarkerInfo> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWeatherData();
    });
    super.initState();
  }

  void getWeatherData() {
    context.read<WeatherAppBloc>().add(
          MarkerInfoWeatherEvent(coordinates: widget.coordinates),
        );
  }

  Widget builder() {
    return BlocBuilder<WeatherAppBloc, WeatherState>(
        buildWhen: (previous, current) {
      return current.type == WeatherStateType.markerInfo;
    }, builder: (context, state) {
      if (state is WeatherErrorState) {
        return ErrorWidget(
          errorMessage: state.error.errorMessage,
          onRetry: getWeatherData,
        );
      } else if (state is MarkerInfoDataLoadedState) {
        return MarkerWeatherInfoCard(weatherData: state.weatherData);
      }
      return FractionallySizedBox(
        heightFactor: 0.3,
        child: WeatherLoadingScreen(
          loadingMessage: 'fetching weather data for selected location...',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return builder();
  }
}
