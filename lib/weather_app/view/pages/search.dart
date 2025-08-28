part of '../../weather_app.dart';

class SearchCityWeather extends StatefulWidget {
  static const String routeName = '/search_city';
  const SearchCityWeather({super.key});

  @override
  State<SearchCityWeather> createState() => _SearchCityWeatherState();
}

class _SearchCityWeatherState extends State<SearchCityWeather> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  final List<String> famousCities = [
    "Delhi",
    "New York",
    "Tokyo",
    "London",
    "Paris",
  ];

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget textField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: "Enter city name...",
        suffixIcon: IconButton(
          onPressed: onSubmitted,
          icon:
              Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
        ),
        filled: true,
        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      onSubmitted: (value) {
        onSubmitted();
      },
    );
  }

  Widget seachHintWidget() {
    return Center(
      child: Column(
        children: [
          Center(
            child: Icon(Icons.cloud_outlined,
                size: 100, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Enter city name to see weather details",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void onSubmitted() {
    _focusNode.unfocus();
    String cityName = _controller.text.trim();
    if (cityName.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid city name"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      return;
    }
    WeatherAppNavigation.instance.pushReplacement(
      CityWeather(cityName: cityName),
    );
  }

  Widget famousCityWidget() {
    return ListView.separated(
      itemCount: famousCities.length,
      separatorBuilder: (_, __) => Divider(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.location_city,
              color: Theme.of(context).colorScheme.primary),
          title: Text(
            famousCities[index],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onTap: () {
            _controller.text = famousCities[index];
            onSubmitted();
          },
        );
      },
    );
  }

  Widget suggestionWidget() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) {
        if (value.text.trim().isNotEmpty) {
          return seachHintWidget();
        } else {
          return famousCityWidget();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: textField(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: suggestionWidget(),
      ),
    );
  }
}
