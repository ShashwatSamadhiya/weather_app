import 'package:flutter/material.dart';
import 'package:weather_app/weather_app/weather_app.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  // bool _isDayTime() {
  //   final hour = DateTime.now().hour;
  //   return hour >= 6 && hour < 18; // 6 AM - 6 PM = day, else night
  // }

  // ThemeData getTheme() {
  //   if (_isDayTime()) {
  //     return WeatherAppTheme.lightTheme;
  //   } else {
  //     return WeatherAppTheme.darkTheme;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeatherWise',
      theme: WeatherAppTheme.darkTheme,
      home: const WeatherHomeScreen(),
    );
  }
}

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("WeatherWise"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sunday, Sep 10",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "7 minutes ago",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Icon(Icons.thunderstorm,
                size: 60, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              "28.8°C",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Thunderstorm - Chandigarh, IN",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Grid of Weather Info
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _infoCard(theme, Icons.cloud, "Feels Like", "35.8°C"),
                _infoCard(theme, Icons.air, "Wind Speed", "14.83 km/h"),
                _infoCard(theme, Icons.water_drop, "Humidity", "94%"),
                _infoCard(theme, Icons.cloud_queue, "Cloud Cover", "75%"),
              ],
            ),
            const SizedBox(height: 20),

            // AQI card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Air Quality Index (PM 10)",
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text("AQI 181 Very Poor",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.error,
                        fontSize: 18,
                      )),
                  const SizedBox(height: 6),
                  Text(
                    "Health warning of emergency conditions: everyone is more likely to be affected.",
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Extra info
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _infoCard(theme, Icons.explore, "Wind Degree", "200° S"),
                _infoCard(theme, Icons.air_outlined, "Wind Gust", "0.00 km/h"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Forecast"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Saved"),
        ],
      ),
    );
  }

  static Widget _infoCard(
      ThemeData theme, IconData icon, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: theme.iconTheme.color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13)),
              Text(value,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
