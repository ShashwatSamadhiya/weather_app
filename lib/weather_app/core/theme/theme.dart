part of weather_app;


class WeatherAppTheme {
  static ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0B0F08),
  primaryColor: Colors.greenAccent,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0B0F08),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.greenAccent),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
    titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
    labelLarge: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.w600),
  ),
  cardTheme: CardTheme(
    color: Color(0xFF101810),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    margin: EdgeInsets.all(8),
    elevation: 2,
  ),
  iconTheme: const IconThemeData(color: Colors.greenAccent),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0B0F08),
    selectedItemColor: Colors.greenAccent,
    unselectedItemColor: Colors.white54,
    showUnselectedLabels: true,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.greenAccent,
    secondary: Colors.green,
    error: Colors.redAccent,
    surface: Color(0xFF101810),
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
);
}