part of weather_app;

/// Splash page for the application.
///
class SplashPage extends StatefulWidget {
  static const String routeName = '/';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLocationPermission();
    });
    super.initState();
  }

  void checkLocationPermission() {
    context.read<WeatherAppBloc>().add(CurrentLocationEvent());
  }

  Widget loadingIndicator({
    String message = "Checking location permission ...",
  }) {
    return WeatherLoadingScreen(
      loadingMessage: message,
    );
  }

  Widget builder() {
    return BlocConsumer<WeatherAppBloc, WeatherState>(
      listener: (BuildContext context, WeatherState state) {
        if (state is LocationPermissionState) {
          WeatherAppNavigation.instance.pushReplacementNamed(
            WeatherHomePage.routeName,
          );
        }
      },
      buildWhen: (previous, current) {
        return current.type == WeatherStateType.location ||
            current.type == WeatherStateType.initial;
      },
      builder: (context, state) {
        if (state.type == WeatherStateType.location &&
            state is WeatherErrorState) {
          return ErrorWidget(
            errorMessage: state.message,
            onRetry: checkLocationPermission,
          );
        }
        if (state is LocationPermissionState) {
          return loadingIndicator(
            message: "Location permission granted. Loading weather data...",
          );
        }
        return loadingIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: builder(),
    );
  }
}
