part of weather_app;

class WeatherAppTheme {
  static ThemeData darkTheme = ThemeData(
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
      titleLarge: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF101810),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
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

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF9FAF9),
    primaryColor: Colors.green,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF9FAF9),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.green),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
      titleLarge: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.all(8),
      elevation: 2,
    ),
    iconTheme: const IconThemeData(color: Colors.green),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF9FAF9),
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black54,
      showUnselectedLabels: true,
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.green,
      secondary: Colors.greenAccent,
      error: Colors.red,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
    ),
  );
}
