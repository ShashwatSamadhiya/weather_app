part of '../../../weather_app.dart';

class ForecastView extends StatefulWidget {
  const ForecastView({super.key});

  @override
  State<ForecastView> createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWheatherData();
    });
    super.initState();
  }

  void getWheatherData() {
    context.read<WeatherAppBloc>().add(WeeklyForecastWeatherEvent());
  }

  Widget forecastList(WeeklyWeatherData data) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forecast")),
      body: ListView.builder(
        itemCount: data.weekWeatherdata.length,
        itemBuilder: (context, index) {
          return ForecastTile(
            dayWeatherData: data.weekWeatherdata[index],
          );
        },
      ),
    );
  }

  Widget builder() {
    return BlocBuilder<WeatherAppBloc, WeatherState>(
        buildWhen: (previous, current) {
      return current.type == WeatherStateType.forecast;
    }, builder: (context, state) {
      if (state is WeatherErrorState) {
        return ErrorWidget(
          errorMessage: state.message,
          onRetry: getWheatherData,
        );
      } else if (state is WeeklyForecastLoadedState) {
        return forecastList(state.weatherData);
      }
      return WeatherLoadingScreen(
        loadingMessage: 'fetching forecast data...',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return builder();
  }
}
