part of '../../../weather_app.dart';

class ForecastTile extends StatelessWidget {
  final DayWeatherData dayWeatherData;

  const ForecastTile({super.key, required this.dayWeatherData});

  Widget tile(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        dayWeatherData.image,
        size: 36,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        dayWeatherData.day,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        dayWeatherData.name,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "↑ ${dayWeatherData.max.toStringAsFixed(1)}°C",
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
          ),
          Text(
            "↓ ${dayWeatherData.min.toStringAsFixed(1)}°C",
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surface,
      child: tile(context),
    );
  }
}
