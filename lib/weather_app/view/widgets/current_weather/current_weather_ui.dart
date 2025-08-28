part of weather_app;

class CurrenWeatherUi extends StatelessWidget {
  final CurrentWeatherData weatherData;
  const CurrenWeatherUi({super.key, required this.weatherData});

  Widget sunriseAndSunsetWidget(BuildContext context) {
    final theme = Theme.of(context);
    final sunrise = DateFormat.Hm().format(
      DateTime.fromMillisecondsSinceEpoch(
        weatherData.sys.sunrise * 1000,
        isUtc: true,
      ).toLocal(),
    );
    final sunset = DateFormat.Hm().format(
      DateTime.fromMillisecondsSinceEpoch(
        weatherData.sys.sunset * 1000,
        isUtc: true,
      ).toLocal(),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.wb_sunny, color: theme.colorScheme.primary),
              const SizedBox(height: 6),
              Text("Sunrise", style: theme.textTheme.bodyMedium),
              Text(sunrise,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  )),
            ],
          ),
          Column(
            children: [
              Icon(Icons.nightlight_round, color: theme.colorScheme.error),
              const SizedBox(height: 6),
              Text("Sunset", style: theme.textTheme.bodyMedium),
              Text(sunset,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoCard(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        InfoCard(
          icon: Icons.thermostat,
          label: "Feels Like",
          value: "${weatherData.main.feelsLike.toStringAsFixed(1)}°C",
        ),
        InfoCard(
          icon: Icons.water_drop,
          label: "Humidity",
          value: "${weatherData.main.humidity}%",
        ),
        InfoCard(
          icon: Icons.remove_red_eye,
          label: "Visibility",
          value: "${(weatherData.visibility / 1000).toStringAsFixed(1)} km",
        ),
        InfoCard(
          icon: Icons.cloud,
          label: "Clouds",
          value: "${weatherData.clouds}%",
        ),
        InfoCard(
          icon: Icons.air,
          label: "Wind Speed",
          value: "${(weatherData.wind.speed).toStringAsFixed(1)} m/s",
        ),
        InfoCard(
          icon: Icons.air,
          label: "Wind Gust",
          value: "${(weatherData.wind.gust).toStringAsFixed(1)} m/s",
        ),
        InfoCard(
          icon: Icons.explore,
          label: "Wind Dir",
          value: "${weatherData.wind.deg}°",
        ),
        InfoCard(
          icon: Icons.compress,
          label: "Pressure",
          value: "${weatherData.main.pressure} hPa",
        ),
      ],
    );
  }

  Widget dataWidget(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(weatherData.image, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          "${weatherData.main.temp.toInt()}°C",
          style: TextStyle(
            fontSize: 36,
            color: theme.colorScheme.primary,
          ),
        ),
        // Text(
        //   "Max: ${weatherData.main.tempMax}°C  •  Min: ${weatherData.main.tempMin}°C",
        //   style: theme.textTheme.bodyMedium?.copyWith(
        //     color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        //   ),
        // ),
        const SizedBox(
          height: 12,
        ),
        Text(
          "${weatherData.weather.first.main} - ${weatherData.weather.first.description}",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        sunriseAndSunsetWidget(context),
        const SizedBox(
          height: 16,
        ),
        infoCard(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("${weatherData.name}, ${weatherData.sys.country}"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: dataWidget(context),
      ),
    );
  }
}
