part of weather_app;

class MarkerWeatherInfoCard extends StatelessWidget {
  final CurrentWeatherData weatherData;

  const MarkerWeatherInfoCard({super.key, required this.weatherData});

  Widget _infoChip({
    required IconData icon,
    required String label,
    required Color color,
    required TextStyle? textStyle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: textStyle?.copyWith(color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${weatherData.name}, ${weatherData.sys.country}",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.thermostat, size: 36, color: theme.colorScheme.error),
              const SizedBox(width: 12),
              Text(
                "${weatherData.main.temp.toInt()}°C",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _infoChip(
                icon: Icons.water_drop,
                label: "${weatherData.main.humidity}%",
                color: theme.colorScheme.primary,
                textStyle: theme.textTheme.bodyMedium,
              ),
              _infoChip(
                icon: weatherData.image,
                label: weatherData.weather.first.main,
                color: theme.colorScheme.secondary,
                textStyle: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
