part of '../../weather_app.dart';

class WeatherHomePage extends StatefulWidget {
  static const String routeName = '/weather_home';
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final ValueNotifier<int> _selectedTabIndex = ValueNotifier<int>(0);

  final _screens = [
    const WeatherView(),
    const ForecastView(),
    const ForecastView(),
  ];

  Widget seletedTabWidget() {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedTabIndex,
      builder: (context, value, child) {
        return IndexedStack(
          index: _selectedTabIndex.value,
          children: _screens,
        );
      },
    );
  }

  void _onTabTapped(int index) {
    _selectedTabIndex.value = index;
  }

  Widget navigationBar() {
    final theme = Theme.of(context);

    return ValueListenableBuilder<int>(
      valueListenable: _selectedTabIndex,
      builder: (context, value, child) {
        return BottomNavigationBar(
          currentIndex: _selectedTabIndex.value,
          onTap: _onTabTapped,
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor:
              theme.colorScheme.onSurface.withValues(alpha: 0.5),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: "Forecast",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: "Map",
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Weather Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              WeatherAppNavigation.instance.pushNamed(
                SearchCityWeather.routeName,
              );
            },
          )
        ],
      ),
      body: seletedTabWidget(),
      bottomNavigationBar: navigationBar(),
    );
  }
}
