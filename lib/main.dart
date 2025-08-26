import 'package:flutter/material.dart';
import 'package:weather_app/weather_app/weather_app.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeatherWise',
      theme: WeatherAppTheme.theme,
      home: const WeatherHomeScreen(),
    );
  }
}

// ------------------- SCREEN -------------------
class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F08),
      appBar: AppBar(
        title: const Text("WeatherWise"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0B0F08),
        elevation: 0,
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
            const Text(
              "Sunday, Sep 10",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            const Text(
              "7 minutes ago",
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.thunderstorm, size: 60, color: Colors.greenAccent),
            const SizedBox(height: 8),
            const Text(
              "28.8°C",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.greenAccent),
            ),
            const SizedBox(height: 8),
            const Text(
              "Thunderstorm - Chandigarh, IN",
              style: TextStyle(color: Colors.white70, fontSize: 16),
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
                _infoCard(Icons.cloud, "Feels Like", "35.8°C"),
                _infoCard(Icons.air, "Wind Speed", "14.83 km/h"),
                _infoCard(Icons.water_drop, "Humidity", "94%"),
                _infoCard(Icons.cloud_queue, "Cloud Cover", "75%"),
              ],
            ),
            const SizedBox(height: 20),

            // AQI card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF123D24),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Air Quality Index (PM 10)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text("AQI 181 Very Poor",
                      style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    "Health warning of emergency conditions: everyone is more likely to be affected.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
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
                _infoCard(Icons.explore, "Wind Degree", "200° S"),
                _infoCard(Icons.air_outlined, "Wind Gust", "0.00 km/h"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B0F08),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Forecast"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Saved"),
        ],
      ),
    );
  }

  static Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101810),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              Text(value,
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
